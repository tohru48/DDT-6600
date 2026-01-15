using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Horse.Handle;
using Game.Server.Packets;
using log4net;

namespace Game.Server.Horse
{
	[HorseProcessorAtribute(40, "礼堂逻辑")]
	public class HorseLogicProcessor : AbstractHorseProcessor
	{
		private static readonly ILog ilog_0;

		private HorseHandleMgr horseHandleMgr_0;

		public HorseLogicProcessor()
		{
			horseHandleMgr_0 = new HorseHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			HorsePackageType horsePackageType = (HorsePackageType)packet.ReadByte();
			try
			{
				IHorseCommandHadler horseCommandHadler = horseHandleMgr_0.LoadCommandHandler((int)horsePackageType);
				if (horseCommandHadler != null)
				{
					horseCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch
			{
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("HorseLogicProcessor HorsePackageType {0} not found!", horsePackageType);
				Console.WriteLine("_______________END_______________");
			}
		}

		static HorseLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
