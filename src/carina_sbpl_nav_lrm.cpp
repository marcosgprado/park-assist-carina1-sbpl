
#include <ros/ros.h>
#include <geometry_msgs/Twist.h>
#include <nav_msgs/Odometry.h>

#include <tf/transform_broadcaster.h>
#include <atuacao/Throttle.h>
#include <atuacao/SteeringAngle.h>


geometry_msgs::Twist base_vel_msg_;
double previous_linear_vel = 0.0;

void commandCallback(const geometry_msgs::TwistConstPtr& msg)
{
  base_vel_msg_ = *msg;

/*
  if ( (base_vel_msg_.linear.x == 0.0) && (base_vel_msg_.linear.y == 0.0) ) 
  {
    if ( base_vel_msg_.angular.z != 0.0) {
       if (previous_linear_vel<0.0) base_vel_msg_.linear.x = -0.1;
       else base_vel_msg_.linear.x = 0.1;
       } 
  }
*/
  previous_linear_vel = base_vel_msg_.linear.x;
}

int main(int argc, char** argv){
  ros::init(argc, argv, "carina_sbpl_nav_lrm");
  ros::NodeHandle n;
  ros::Subscriber cmd_sub_;  // To handle references 

  ros::Publisher cmd_pub_;
  ros::Publisher throttle_pub;
  ros::Publisher steering_pub;
  ros::Rate r(20);

  atuacao::Throttle throttle;
  atuacao::SteeringAngle steer;

  geometry_msgs::Twist cmd_vel_; 
  float pose_x, pose_y;


  tf::TransformBroadcaster broadcaster;


  cmd_pub_ = n.advertise<geometry_msgs::Twist>("/cmd_vel", 20);

  throttle_pub = n.advertise<atuacao::Throttle> ("throttle_commands",1);

  steering_pub = n.advertise<atuacao::SteeringAngle> ("steering_commands",1);

  cmd_sub_ = n.subscribe<geometry_msgs::Twist>("/cmd_vel1", 1, &commandCallback );


 ROS_INFO("carina_sbpl_nav_lrm node loaded!");

  while(n.ok()){


	throttle.value = (int)(base_vel_msg_.linear.x * 100) ;
    steer.angle = 57.3 * base_vel_msg_.angular.z; // radianos p/ graus


    //publish the message
    cmd_pub_.publish(base_vel_msg_);

    throttle_pub.publish(throttle);

    steering_pub.publish(steer);


    // tf: /map -> /odom
    //broadcaster.sendTransform(tf::StampedTransform(tf::Transform(tf::Quaternion(0, 0, 0.0, 1), tf::Vector3(0.0,0.0,0.0)),ros::Time::now(),"map", "odom"));

   //  broadcaster.sendTransform(tf::StampedTransform(tf::Transform(tf::Quaternion(0, 0, 0.92, 1), tf::Vector3(12,15.4,0)),ros::Time::now(),"map", "odom"));

   // broadcaster.sendTransform(tf::StampedTransform(tf::Transform(tf::Quaternion(0, 0, 0, 1), tf::Vector3(42.20, 50.20, 0)),ros::Time::now(),"map", "odom"));

   // broadcaster.sendTransform(tf::StampedTransform(tf::Transform(tf::Quaternion(0, 0, 0.92, 1), tf::Vector3(12.8,14.2,0)),ros::Time::now(),"map", "odom"));

   // broadcaster.sendTransform(tf::StampedTransform(tf::Transform(tf::Quaternion(0, 0, 0.0, 1), tf::Vector3(40.6, 39.3, 0.0)),ros::Time::now(),"map", "odom"));

   // tf: /odom -> /base_footprint  (transform should thus give the height above ground as the z-component)
   //broadcaster.sendTransform(tf::StampedTransform(tf::Transform(tf::Quaternion(0, 0, 0, 1), tf::Vector3(pose_x, pose_y, 0.0)),ros::Time::now(),"odom", "base_footprint"));


    ros::spinOnce();
    r.sleep();
  }
}

