using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(18, "场景用户离开")]
	public class CardInfoHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			GamePlayer playerById = WorldMgr.GetPlayerById(num);
			PlayerInfo playerInfo;
			List<UsersCardInfo> list;
			if (playerById != null)
			{
				playerInfo = playerById.PlayerCharacter;
				list = playerById.CardBag.GetCards(0, 5);
			}
			else
			{
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				playerInfo = playerBussiness.GetUserSingleByUserID(num);
				list = playerBussiness.GetUserCardEuqip(num);
			}
			if (list != null && playerInfo != null)
			{
				playerInfo.ZoneID = client.Player.ZoneId;
				client.Player.Out.SendPlayerCardSlot(playerInfo, list);
				client.Player.Out.SendPlayerCardEquip(playerInfo, list);
			}
			return 0;
		}
	}
}
