using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.ActiveSystem.Handle;
using Game.Server.GameObjects;
using Game.Server.Packets;
using log4net;

namespace Game.Server.ActiveSystem
{
	[ActiveSystemProcessorAtribute(byte.MaxValue, "礼堂逻辑")]
	public class ActiveSystemLogicProcessor : AbstractActiveSystemProcessor
	{
		private static readonly ILog ilog_0;

		private ActiveSystemHandleMgr activeSystemHandleMgr_0;

		public ActiveSystemLogicProcessor()
		{
			activeSystemHandleMgr_0 = new ActiveSystemHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			ActiveSystemPackageType activeSystemPackageType = (ActiveSystemPackageType)packet.ReadByte();
			try
			{
				IActiveSystemCommandHadler activeSystemCommandHadler = activeSystemHandleMgr_0.LoadCommandHandler((int)activeSystemPackageType);
				if (activeSystemCommandHadler != null)
				{
					activeSystemCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch (Exception ex)
			{
				ilog_0.Error(string.Format("ActiveSystemPackageType: {1}, OnGameData is Error: {0}", ex.ToString(), activeSystemPackageType));
			}
		}

		static ActiveSystemLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
