using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(105, "场景用户离开")]
	public class MissionEnergyHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			packet.ReadBoolean();
			PlayerExtra extra = client.Player.Extra;
			if (extra.Info.buyEnergyCount == 0)
			{
				extra.Info.buyEnergyCount = 1;
			}
			if (extra.Info.MissionEnergy <= 250)
			{
				MissionEnergyInfo missionEnergyInfo = MissionEnergyMgr.GetMissionEnergyInfo(extra.Info.buyEnergyCount);
				if (missionEnergyInfo != null)
				{
					if (client.Player.MoneyDirect(missionEnergyInfo.Money))
					{
						client.Player.AddMissionEnergy(missionEnergyInfo.Energy);
						extra.Info.buyEnergyCount++;
						client.Player.SendMessage(LanguageMgr.GetTranslation("MissionEnergyHandler.Msg1"));
					}
				}
				else
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("MissionEnergyHandler.Msg2"));
				}
			}
			else
			{
				client.Player.SendMessage(LanguageMgr.GetTranslation("MissionEnergyHandler.Msg3"));
			}
			client.Player.Out.SendMissionEnergy(extra.Info);
			return 0;
		}
	}
}
