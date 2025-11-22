#include <iostream>
#include <libplayerc++/playerc++.h>
#include <cmath>

#define POSITION_TOLERANCE 0.69
#define ERROR_NO_ARGUMENTS -2
#define ERROR_PLAYERC -1


bool hasArrived(PlayerCc::Position2dProxy* position, const double destinyX, const double destinyY, const double destinyYaw)
{  
  return std::abs(destinyX - position->GetXPos())  < POSITION_TOLERANCE &&
         std::abs(destinyY - position->GetYPos())   < POSITION_TOLERANCE &&
         std::abs(destinyYaw - position->GetYaw()) < POSITION_TOLERANCE;
}

void moveTo(PlayerCc::PlayerClient* client, PlayerCc::Position2dProxy* algorithmProxy, const double X, const double Y, const double Yaw)
{
  algorithmProxy->GoTo(X, Y, Yaw);
  while(!hasArrived(algorithmProxy, X, Y, Yaw)){
    algorithmProxy->RequestGeom();
    client->Read();

    //std::cout << "X: " << algorithmProxy->GetXPos() << std::endl;
    //std::cout << "Y: " << algorithmProxy->GetYPos() << std::endl;
    //std::cout << "Yaw: " << algorithmProxy->GetYaw() << std::endl;

    algorithmProxy->GoTo(X - algorithmProxy->GetXPos(), Y - algorithmProxy->GetYPos(), Yaw - algorithmProxy->GetYaw());
   }
 
}


int main(int argc, char *argv[]){
  std::string player_hostname = PlayerCc::PLAYER_HOSTNAME;
  int player_port = PlayerCc::PLAYER_PORTNUM;

  if (argc < 4){
    std::cerr << "Usage: " << argv[0] << " X Y Yaw [hostname] [port]" << std::endl;
    return ERROR_NO_ARGUMENTS;
   }
  
  const double X = std::stod(argv[1]);
  const double Y = std::stod(argv[2]);
  const double Yaw = std::stod(argv[3]);
  
  if (argc == 5)
    player_hostname = argv[4];
  if(argc == 6)
    player_port = std::stoi(argv[5]);

  try 
  {
    PlayerCc::PlayerClient robot{player_hostname, player_port};
    PlayerCc::Position2dProxy algorithmProxy{&robot, 1};

    PlayerCc::LogProxy logProxy{&robot, 0};
    logProxy.SetState(1);
    logProxy.SetWriteState(1);

    moveTo(&robot, &algorithmProxy, X, Y, Yaw);
    std::cout << "Arrived to destiny" << std::endl;

    logProxy.SetWriteState(0);
  }
  catch(PlayerCc::PlayerError& e)
  {
    std::cerr << e << std::endl;
    return ERROR_PLAYERC;
  }

  return 0;
}
