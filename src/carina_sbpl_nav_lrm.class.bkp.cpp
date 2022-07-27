#include <ros/ros.h>
#include <geometry_msgs/Twist.h>
#include <nav_msgs/Odometry.h>

#include <tf/transform_broadcaster.h>
#include <atuacao/Throttle.h>
#include <atuacao/SteeringAngle.h>

class CarinaSbpl{

private:

	  ros::NodeHandle nh, nh_priv;
	  ros::Subscriber cmd_sub_;  // To handle references

	  ros::Publisher cmd_pub_;
	  ros::Publisher throttle_pub;
	  ros::Publisher steering_pub;
	  ros::Timer pubCommTimer;
	  ros::Timer pubTfTimer;

	  tf::TransformBroadcaster broadcaster;

	  geometry_msgs::Twist cmd_vel_;
	  double pose_x;
	  double pose_y;
	  double yal;
	  double pub_comm_freq;
	  double pub_tf_freq;

	  geometry_msgs::Twist base_vel_msg_;
	  double previous_linear_vel;

public:


	  CarinaSbpl(ros::NodeHandle n) :
		  nh(n), nh_priv("~"){


		  nh_priv.param("pose_x", pose_x, 0.0);
		  nh_priv.param("pose_y", pose_y, 0.0);
		  nh_priv.param("yal", yal, 0.0);
		  nh_priv.param("pub_comm_freq", pub_comm_freq, 20.0);
		  nh_priv.param("pub_tf_freq",pub_tf_freq, 20.0);



		  cmd_sub_ = nh.subscribe<geometry_msgs::Twist>("/cmd_vel1", 1, &CarinaSbpl::commandCallback, this);


		  cmd_pub_ = nh.advertise<geometry_msgs::Twist>("/cmd_vel", 20, 0);

		  throttle_pub = nh.advertise<atuacao::Throttle> ("throttle_command",1, 0);

		  steering_pub = nh.advertise<atuacao::SteeringAngle> ("steering_command",1, 0);



		  pubCommTimer = n.createTimer(ros::Duration(pub_comm_freq), &CarinaSbpl::commandPublisherCallback, this);

		  //pubTfTimer = n.createTimer(ros::Duration(pub_tf_freq), &CarinaSbpl::tfPublisherCallback, this);


		  this->previous_linear_vel = 0.0;

	  }

~CarinaSbpl(){

}

geometry_msgs::Twist get_base_vel_msg_(){

	return this->base_vel_msg_;
}

void set_base_vel_msg_(const geometry_msgs::TwistConstPtr& base){

	this->base_vel_msg_ = *base;
}


void commandCallback(const geometry_msgs::TwistConstPtr& msg)
{

	set_base_vel_msg_(msg);

/*
  if ( (base_vel_msg_.linear.x == 0.0) && (base_vel_msg_.linear.y == 0.0) ) 
  {
    if ( base_vel_msg_.angular.z != 0.0) {
       if (previous_linear_vel<0.0) base_vel_msg_.linear.x = -0.1;
       else base_vel_msg_.linear.x = 0.1;
       } 
  }
*/
  //previous_linear_vel = base_vel_msg_.linear.x;
}


void commandPublisherCallback(const ros::TimerEvent&){


	    atuacao::Throttle throttle;
		atuacao::SteeringAngle steer;

	    throttle.value = (int)(get_base_vel_msg_().linear.x * 100) ;
	    steer.angle = 57.3 * get_base_vel_msg_().angular.z; // radianos p/ graus


	    //publish the message
	    cmd_pub_.publish(get_base_vel_msg_());

	    throttle_pub.publish(throttle);

	    steering_pub.publish(steer);




}


void tfPublisher(void){

	this->broadcaster.sendTransform(tf::StampedTransform(tf::Transform(tf::Quaternion(0, 0, yal, 1), tf::Vector3(pose_x,pose_y,0.0)),ros::Time::now(),"map", "odom"));

}


};


int main(int argc, char** argv){

	ros::init(argc, argv, "carina_sbpl_nav_lrm");
    ros::NodeHandle n;
    ros::Rate r(20);

    CarinaSbpl carina_sbpl(n);

    ROS_INFO("carina_sbpl_nav_lrm node loaded!");

    ros::spin();

    while(n.ok()){

    carina_sbpl.tfPublisher();

    ros::spinOnce();
    r.sleep();
    }

}
