using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(86, "任务完成")]
	public class QuestOneKeyFinishHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int id = packet.ReadInt();
			QuestInfo singleQuest = QuestMgr.GetSingleQuest(id);
			if (singleQuest != null && client.Player.isInLimitTimes() > 0)
			{
				if (client.Player.MoneyDirect(singleQuest.OneKeyFinishNeedMoney))
				{
					client.Player.PlayerCharacter.uesedFinishTime++;
					int num = 0;
					List<QuestConditionInfo> questCondiction = QuestMgr.GetQuestCondiction(singleQuest);
					foreach (QuestConditionInfo item in questCondiction)
					{
						client.Player.OnQuestOneKeyFinishEvent(item);
						num++;
					}
					if (num > 0)
					{
						GSPacketIn gSPacketIn = new GSPacketIn(86, client.Player.PlayerId);
						gSPacketIn.WriteInt(client.Player.PlayerCharacter.uesedFinishTime);
						client.Player.SendTCP(gSPacketIn);
					}
				}
			}
			else
			{
				client.Player.SendMessage(LanguageMgr.GetTranslation("QuestOneKeyFinishHandler.Msg"));
			}
			return 0;
		}
	}
}
