using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.FlowerGiving.Handle;
using Game.Server.GameObjects;
using Game.Server.Packets;
using log4net;

namespace Game.Server.FlowerGiving
{
	[FlowerGivingProcessorAtribute(40, "礼堂逻辑")]
	public class FlowerGivingLogicProcessor : AbstractFlowerGivingProcessor
	{
		private static readonly ILog ilog_0;

		private FlowerGivingHandleMgr flowerGivingHandleMgr_0;

		public FlowerGivingLogicProcessor()
		{
			flowerGivingHandleMgr_0 = new FlowerGivingHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			FlowerGivingPackageType code = (FlowerGivingPackageType)packet.ReadByte();
			try
			{
				IFlowerGivingCommandHadler flowerGivingCommandHadler = flowerGivingHandleMgr_0.LoadCommandHandler((int)code);
				if (flowerGivingCommandHadler != null)
				{
					flowerGivingCommandHadler.CommandHandler(player, packet);
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

		static FlowerGivingLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
