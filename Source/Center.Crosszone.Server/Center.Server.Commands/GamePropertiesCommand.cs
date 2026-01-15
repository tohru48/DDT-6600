using Game.Base;
using System;
namespace Center.Server.Commands
{
	public class GamePropertiesCommand : AbstractCommandHandler, ICommandHandler
	{
		public bool OnCommand(BaseClient client, string[] args)
		{
			return true;
		}
		public GamePropertiesCommand()
		{
			
			
		}
	}
}
