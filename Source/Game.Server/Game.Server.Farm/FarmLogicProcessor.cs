using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.Farm.Handle;
using Game.Server.GameObjects;
using Game.Server.Packets;
using log4net;

namespace Game.Server.Farm
{
	[FarmProcessorAtribute(99, "礼堂逻辑")]
	public class FarmLogicProcessor : AbstractFarmProcessor
	{
		private static readonly ILog ilog_0;

		private FarmHandleMgr farmHandleMgr_0;

		public FarmLogicProcessor()
		{
			farmHandleMgr_0 = new FarmHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			FarmPackageType code = (FarmPackageType)packet.ReadByte();
			try
			{
				IFarmCommandHadler farmCommandHadler = farmHandleMgr_0.LoadCommandHandler((int)code);
				if (farmCommandHadler != null)
				{
					farmCommandHadler.CommandHandler(player, packet);
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

		static FarmLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
