using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.BombKing.Handle;
using Game.Server.GameObjects;
using Game.Server.Packets;
using log4net;

namespace Game.Server.BombKing
{
	[BombKingProcessorAtribute(40, "礼堂逻辑")]
	public class BombKingLogicProcessor : AbstractBombKingProcessor
	{
		private static readonly ILog ilog_0;

		private BombKingHandleMgr bombKingHandleMgr_0;

		public BombKingLogicProcessor()
		{
			bombKingHandleMgr_0 = new BombKingHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			BombKingPackageType bombKingPackageType = (BombKingPackageType)packet.ReadByte();
			try
			{
				IBombKingCommandHadler bombKingCommandHadler = bombKingHandleMgr_0.LoadCommandHandler((int)bombKingPackageType);
				if (bombKingCommandHadler != null)
				{
					bombKingCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch (Exception)
			{
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("BombKingLogicProcessor PackageType {0} not found!", bombKingPackageType);
				Console.WriteLine("_______________END_______________");
			}
		}

		static BombKingLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
