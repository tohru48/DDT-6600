using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.RingStation.RoomGamePkg.TankHandle;
using log4net;

namespace Game.Server.RingStation.RoomGamePkg
{
	[GameProcessor(99, "礼堂逻辑")]
	public class RingStationRoomLogicProcessor : AbstractGameProcessor
	{
		private GameCommandMgr gameCommandMgr_0;

		private static readonly ILog ilog_0;

		public readonly int TIMEOUT;

		public override void OnGameData(RoomGame room, RingStationGamePlayer player, GSPacketIn packet)
		{
			GameCmdType code = (GameCmdType)packet.Code;
			try
			{
				IGameCommandHandler gameCommandHandler = gameCommandMgr_0.LoadCommandHandler((int)code);
				if (gameCommandHandler != null)
				{
					gameCommandHandler.HandleCommand(this, player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch (Exception ex)
			{
				ilog_0.Error($" RingStationLogic OnGameData is Error: {ex.ToString()}, type: {code}");
			}
		}

		public override void OnTick(RoomGame room)
		{
		}

		public RingStationRoomLogicProcessor()
		{
			gameCommandMgr_0 = new GameCommandMgr();
			TIMEOUT = 60000;
		}

		static RingStationRoomLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
