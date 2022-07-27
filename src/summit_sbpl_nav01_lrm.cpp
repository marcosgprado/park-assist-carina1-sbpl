

#include <ros/ros.h>
#include <tf/transform_broadcaster.h>


int main(int argc, char** argv){
  ros::init(argc, argv, "summit_sbpl_nav");
  ros::NodeHandle n;
  
  ros::Rate r(50);

  tf::TransformBroadcaster broadcaster;

  ROS_INFO("summit_sbpl_nav node loaded!");

  while(n.ok()){

  // tf: /base_link -> /hokuyo_laser_link
    broadcaster.sendTransform(tf::StampedTransform(tf::Transform(tf::Quaternion(0, 0, 0, 1), tf::Vector3(4.5,7.0,0.0)),ros::Time::now(),"map", "odom"));
    

    // tf: /base_footprint -> /base_link  (transform should thus give the height above ground as the z-component)
    broadcaster.sendTransform(tf::StampedTransform(tf::Transform(tf::Quaternion(0, 0, 0, 1), tf::Vector3(0.0,0.0,0.0)),ros::Time::now(),"odom", "base_footprint"));

    
    ros::spinOnce();
    r.sleep();
  }
}
