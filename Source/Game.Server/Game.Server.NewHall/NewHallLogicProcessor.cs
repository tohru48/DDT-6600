using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.NewHall.Handle;
using Game.Server.Packets;
using log4net;

namespace Game.Server.NewHall
{
	[NewHallProcessorAtribute(40, "礼堂逻辑")]
	public class NewHallLogicProcessor : AbstractNewHallProcessor
	{
		private static readonly ILog ilog_0;

		private NewHallHandleMgr newHallHandleMgr_0;

		public NewHallLogicProcessor()
		{
			newHallHandleMgr_0 = new NewHallHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			NewHallPackageType code = (NewHallPackageType)packet.ReadByte();
			try
			{
				INewHallCommandHadler newHallCommandHadler = newHallHandleMgr_0.LoadCommandHandler((int)code);
				if (newHallCommandHadler != null)
				{
					newHallCommandHadler.CommandHandler(player, packet);
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

		static NewHallLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
