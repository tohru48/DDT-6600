using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Farm.Handle
{
	[Attribute5(21)]
	public class FarmPoultryLevel : IFarmCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			UserFarmInfo userFarmInfo = ((num != Player.PlayerCharacter.ID) ? Player.Farm.OtherFarm : Player.Farm.CurrentFarm);
			if (userFarmInfo != null)
			{
				TreeTemplateInfo treeTemplateInfo = TreeTemplateMgr.FindNextTreeTemplate(userFarmInfo.TreeLevel + 1);
				Player.Out.SendFarmPoultryLevel(Player.PlayerId, userFarmInfo, treeTemplateInfo.Level);
			}
			return true;
		}
	}
}
