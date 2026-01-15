using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.DragonBoat.Handle;
using Game.Server.GameObjects;
using Game.Server.Packets;
using log4net;

namespace Game.Server.DragonBoat
{
	[DragonBoatProcessorAtribute(40, "礼堂逻辑")]
	public class DragonBoatLogicProcessor : AbstractDragonBoatProcessor
	{
		private static readonly ILog ilog_0;

		private DragonBoatHandleMgr dragonBoatHandleMgr_0;

		public DragonBoatLogicProcessor()
		{
			dragonBoatHandleMgr_0 = new DragonBoatHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			DragonBoatPackageType code = (DragonBoatPackageType)packet.ReadByte();
			try
			{
				IDragonBoatCommandHadler dragonBoatCommandHadler = dragonBoatHandleMgr_0.LoadCommandHandler((int)code);
				if (dragonBoatCommandHadler != null)
				{
					dragonBoatCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch (Exception ex)
			{
				ilog_0.Error(string.Format("IP:{1}, OnGameData is Error: {0}", ex.ToString(), player.Client.TcpEndpoint));
			}
		}

		static DragonBoatLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
