#include <iostream>
#include <libplayerc++/playerc++.h>


int main(int argc, char *argv[]){
  std::string player_hostname = PlayerCc::PLAYER_HOSTNAME;
  int player_port = PlayerCc::PLAYER_PORTNUM;

  
  const double speed = 0.1;
  const int rotation_radians = PlayerCc::dtor(0);
  try 
  {
    PlayerCc::PlayerClient robot{player_hostname, player_port};
    PlayerCc::Position2dProxy positionProxy{&robot, 0};
    PlayerCc::Position2dProxy algorithmProxy{&robot, 1};

    PlayerCc::LogProxy logProxy{&robot, 0};
    logProxy.SetState(1);
    logProxy.SetWriteState(1);

    PlayerCc::player_pose2d

    logProxy.SetWriteState(0);
    positionProxy.SetSpeed(0.0, 0.0);
  }
  catch(PlayerCc::PlayerError& e)
  {
    std::cerr << e << std::endl;
    return -1;
  }

  return 0;
}
