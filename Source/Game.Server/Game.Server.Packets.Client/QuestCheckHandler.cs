using Game.Base.Packets;
using Game.Server.Quests;

namespace Game.Server.Packets.Client
{
	[PacketHandler(181, "客服端任务检查")]
	public class QuestCheckHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int id = packet.ReadInt();
			int id2 = packet.ReadInt();
			int value = packet.ReadInt();
			BaseQuest baseQuest = client.Player.QuestInventory.FindQuest(id);
			if (baseQuest != null && baseQuest.GetConditionById(id2) is ClientModifyCondition clientModifyCondition)
			{
				clientModifyCondition.Value = value;
			}
			return 0;
		}
	}
}
