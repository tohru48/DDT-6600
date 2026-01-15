using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.AvatarCollection.Handle;
using Game.Server.GameObjects;
using Game.Server.Packets;
using log4net;

namespace Game.Server.AvatarCollection
{
	[AvatarCollectionProcessorAtribute(40, "礼堂逻辑")]
	public class AvatarCollectionLogicProcessor : AbstractAvatarCollectionProcessor
	{
		private static readonly ILog ilog_0;

		private AvatarCollectionHandleMgr avatarCollectionHandleMgr_0;

		public AvatarCollectionLogicProcessor()
		{
			avatarCollectionHandleMgr_0 = new AvatarCollectionHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			AvatarCollectionPackageType avatarCollectionPackageType = (AvatarCollectionPackageType)packet.ReadByte();
			try
			{
				IAvatarCollectionCommandHadler avatarCollectionCommandHadler = avatarCollectionHandleMgr_0.LoadCommandHandler((int)avatarCollectionPackageType);
				if (avatarCollectionCommandHadler != null)
				{
					avatarCollectionCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch (Exception arg)
			{
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("AvatarCollectionLogicProcessor PackageType {0} not found!", avatarCollectionPackageType);
				ilog_0.Error($"Detail: {arg}");
				Console.WriteLine("_______________END_______________");
			}
		}

		static AvatarCollectionLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
