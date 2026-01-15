using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GameRoom.Handle;
using Game.Server.Packets;
using log4net;

namespace Game.Server.GameRoom
{
	[GameRoomProcessorAtribute(40, "礼堂逻辑")]
	public class GameRoomLogicProcessor : AbstractGameRoomProcessor
	{
		private static readonly ILog ilog_0;

		private GameRoomHandleMgr gameRoomHandleMgr_0;

		public GameRoomLogicProcessor()
		{
			gameRoomHandleMgr_0 = new GameRoomHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			GameRoomPackageType gameRoomPackageType = (GameRoomPackageType)packet.ReadInt();
			try
			{
				IGameRoomCommandHadler gameRoomCommandHadler = gameRoomHandleMgr_0.LoadCommandHandler((int)gameRoomPackageType);
				if (gameRoomCommandHadler != null)
				{
					gameRoomCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("GameRoomLogicProcessor PackageType {0} not found!", gameRoomPackageType);
				Console.WriteLine("_______________END_______________");
			}
			catch (Exception ex)
			{
				ilog_0.Error(string.Format("IP:{1}, OnGameData is Error: {0}", ex.ToString(), player.Client.TcpEndpoint));
			}
		}

		static GameRoomLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
