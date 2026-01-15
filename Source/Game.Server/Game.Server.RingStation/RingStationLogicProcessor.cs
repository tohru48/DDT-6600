using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.RingStation.Handle;
using log4net;

namespace Game.Server.RingStation
{
	[RingStationProcessorAtribute(40, "礼堂逻辑")]
	public class RingStationLogicProcessor : AbstractRingStationProcessor
	{
		private static readonly ILog ilog_0;

		private RingStationHandleMgr ringStationHandleMgr_0;

		public RingStationLogicProcessor()
		{
			ringStationHandleMgr_0 = new RingStationHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			RingStationPackageType ringStationPackageType = (RingStationPackageType)packet.ReadByte();
			try
			{
				IRingStationCommandHadler ringStationCommandHadler = ringStationHandleMgr_0.LoadCommandHandler((int)ringStationPackageType);
				if (ringStationCommandHadler != null)
				{
					ringStationCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch
			{
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("RingStationLogicProcessor PackageType {0} not found!", ringStationPackageType);
				Console.WriteLine("_______________END_______________");
			}
		}

		static RingStationLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
