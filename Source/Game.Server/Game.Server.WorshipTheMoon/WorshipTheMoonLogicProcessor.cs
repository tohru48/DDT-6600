using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.WorshipTheMoon.Handle;
using log4net;

namespace Game.Server.WorshipTheMoon
{
	[WorshipTheMoonProcessorAtribute(byte.MaxValue, "礼堂逻辑")]
	public class WorshipTheMoonLogicProcessor : AbstractWorshipTheMoonProcessor
	{
		private static readonly ILog ilog_0;

		private WorshipTheMoonHandleMgr worshipTheMoonHandleMgr_0;

		public WorshipTheMoonLogicProcessor()
		{
			worshipTheMoonHandleMgr_0 = new WorshipTheMoonHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			WorshipTheMoonPackageType worshipTheMoonPackageType = (WorshipTheMoonPackageType)packet.ReadByte();
			try
			{
				IWorshipTheMoonCommandHadler worshipTheMoonCommandHadler = worshipTheMoonHandleMgr_0.LoadCommandHandler((int)worshipTheMoonPackageType);
				if (worshipTheMoonCommandHadler != null)
				{
					worshipTheMoonCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch (Exception ex)
			{
				ilog_0.Error(string.Format("WorshipTheMoonPackageType: {1}, OnGameData is Error: {0}", ex.ToString(), worshipTheMoonPackageType));
			}
		}

		static WorshipTheMoonLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
