using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.MagicHouse.Handle;
using Game.Server.Packets;
using log4net;

namespace Game.Server.MagicHouse
{
	[MagicHouseProcessorAtribute(40, "礼堂逻辑")]
	public class MagicHouseLogicProcessor : AbstractMagicHouseProcessor
	{
		private static readonly ILog ilog_0;

		private MagicHouseHandleMgr magicHouseHandleMgr_0;

		public MagicHouseLogicProcessor()
		{
			magicHouseHandleMgr_0 = new MagicHouseHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			MagicHousePackageTypeIn code = (MagicHousePackageTypeIn)packet.ReadInt();
			try
			{
				IMagicHouseCommandHadler magicHouseCommandHadler = magicHouseHandleMgr_0.LoadCommandHandler((int)code);
				if (magicHouseCommandHadler != null)
				{
					magicHouseCommandHadler.CommandHandler(player, packet);
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

		static MagicHouseLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
