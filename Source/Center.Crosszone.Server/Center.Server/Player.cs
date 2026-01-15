using System;
namespace Center.Server
{
	public class Player
	{
		public int Id;
		public string Name;
		public string NickName;
		public string Password;
		public long LastTime;
		public bool IsFirst;
		public ePlayerState State;
		public ServerClient CurrentServer;
		public Player()
		{
			
			
		}
	}
}
