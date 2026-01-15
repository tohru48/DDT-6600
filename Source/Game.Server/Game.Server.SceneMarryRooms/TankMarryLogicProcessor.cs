using System;
using System.Reflection;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Game.Server.SceneMarryRooms.TankHandle;
using log4net;

namespace Game.Server.SceneMarryRooms
{
	[MarryProcessor(10, "礼堂逻辑")]
	public class TankMarryLogicProcessor : AbstractMarryProcessor
	{
		private MarryCommandMgr marryCommandMgr_0;

		private ThreadSafeRandom threadSafeRandom_0;

		public readonly int TIMEOUT;

		private static readonly ILog ilog_0;

		public TankMarryLogicProcessor()
		{
			threadSafeRandom_0 = new ThreadSafeRandom();
			TIMEOUT = 60000;
			marryCommandMgr_0 = new MarryCommandMgr();
		}

		public override void OnTick(MarryRoom room)
		{
			try
			{
				if (room != null)
				{
					room.KickAllPlayer();
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						playerBussiness.DisposeMarryRoomInfo(room.Info.ID);
					}
					GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(room.Info.GroomID);
					GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(room.Info.BrideID);
					GameServer.Instance.LoginServer.SendMarryRoomInfoToPlayer(room.Info.GroomID, state: false, room.Info);
					GameServer.Instance.LoginServer.SendMarryRoomInfoToPlayer(room.Info.BrideID, state: false, room.Info);
					MarryRoomMgr.RemoveMarryRoom(room);
					GSPacketIn gSPacketIn = new GSPacketIn(254);
					gSPacketIn.WriteInt(room.Info.ID);
					WorldMgr.MarryScene.method_0(gSPacketIn);
					room.StopTimer();
				}
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("OnTick", exception);
				}
			}
		}

		public override void OnGameData(MarryRoom room, GamePlayer player, GSPacketIn packet)
		{
			MarryCmdType code = (MarryCmdType)packet.ReadByte();
			try
			{
				IMarryCommandHandler marryCommandHandler = marryCommandMgr_0.LoadCommandHandler((int)code);
				if (marryCommandHandler != null)
				{
					marryCommandHandler.HandleCommand(this, player, packet);
				}
				else
				{
					ilog_0.Error($"IP: {player.Client.TcpEndpoint}");
				}
			}
			catch (Exception ex)
			{
				ilog_0.Error(string.Format("IP:{1}, OnGameData is Error: {0}", ex.ToString(), player.Client.TcpEndpoint));
			}
		}

		static TankMarryLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
