using System;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Pet.Handle;
using log4net;

namespace Game.Server.Pet
{
	[PetProcessorAtribute(40, "礼堂逻辑")]
	public class PetLogicProcessor : AbstractPetProcessor
	{
		private static readonly ILog ilog_0;

		private PetHandleMgr petHandleMgr_0;

		public PetLogicProcessor()
		{
			petHandleMgr_0 = new PetHandleMgr();
		}

		public override void OnGameData(GamePlayer player, GSPacketIn packet)
		{
			PetPackageType petPackageType = (PetPackageType)packet.ReadByte();
			try
			{
				IPetCommandHadler petCommandHadler = petHandleMgr_0.LoadCommandHandler((int)petPackageType);
				if (petCommandHadler != null)
				{
					petCommandHadler.CommandHandler(player, packet);
					return;
				}
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("LoadCommandHandler not found!");
				Console.WriteLine("_______________END_______________");
			}
			catch
			{
				Console.WriteLine("______________ERROR______________");
				Console.WriteLine("PetLogicProcessor PackageType {0} not found!", petPackageType);
				Console.WriteLine("_______________END_______________");
			}
		}

		static PetLogicProcessor()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
