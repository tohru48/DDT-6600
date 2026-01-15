using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.MagicStone.Handle;
using Game.Server.Packets;
using log4net;

namespace Game.Server.MagicStone
{
	[MagicStoneProcessorAtribute(40, "礼堂逻辑")]
	public class MagicStoneLogicProcessor : AbstractMagicStoneProcessor
	{
		private static readonly ILog ilog_0;

		private MagicStoneHandleMgr magicStoneHandleMgr_0;

		public MagicStoneLogicProcessor()
		{
			magicStoneHandleMgr_0 = new MagicStoneHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			MagicStonePackageType code = (MagicStonePackageType)packet.ReadByte();
			try
			{
				IMagicStoneCommandHadler magicStoneCommandHadler = magicStoneHandleMgr_0.LoadCommandHandler((int)code);
				if (magicStoneCommandHadler != null)
				{
					magicStoneCommandHadler.CommandHandler(player, packet);
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

		static MagicStoneLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
