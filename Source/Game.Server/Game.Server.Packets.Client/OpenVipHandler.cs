using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
	[PacketHandler(92, "场景用户离开")]
	public class OpenVipHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			string text = packet.ReadString();
			int num = packet.ReadInt();
			int value = 569;
			int num2 = 569;
			int num3 = 1707;
			int num4 = 3000;
			string translation = LanguageMgr.GetTranslation("OpenVipHandler.Msg1");
			string translation2 = LanguageMgr.GetTranslation("OpenVipHandler.Msg1");
			int num5 = num;
			switch (num5)
			{
			case 180:
				value = num4;
				break;
			case 90:
				value = num3;
				break;
			case 30:
				value = num2;
				break;
			}
			GamePlayer clientByPlayerNickName = WorldMgr.GetClientByPlayerNickName(text);
			if (client.Player.MoneyDirect(value))
			{
				DateTime ExpireDayOut = DateTime.Now;
				using PlayerBussiness playerBussiness = new PlayerBussiness();
				playerBussiness.method_0(text, num, ref ExpireDayOut);
				if (clientByPlayerNickName == null)
				{
					translation = LanguageMgr.GetTranslation("OpenVipHandler.Msg2", text);
				}
				else if (client.Player.PlayerCharacter.NickName == text)
				{
					if (client.Player.PlayerCharacter.typeVIP == 0)
					{
						client.Player.OpenVIP(ExpireDayOut, num5);
					}
					else
					{
						client.Player.ContinousVIP(ExpireDayOut, num5);
						translation = LanguageMgr.GetTranslation("OpenVipHandler.Msg3");
					}
					client.Out.imethod_2(client.Player.PlayerCharacter);
				}
				else
				{
					if (clientByPlayerNickName.PlayerCharacter.typeVIP == 0)
					{
						clientByPlayerNickName.OpenVIP(ExpireDayOut, num5);
						translation = LanguageMgr.GetTranslation("OpenVipHandler.Msg4", text);
						translation2 = LanguageMgr.GetTranslation("OpenVipHandler.Msg5", client.Player.PlayerCharacter.NickName);
					}
					else
					{
						clientByPlayerNickName.ContinousVIP(ExpireDayOut, num5);
						translation = LanguageMgr.GetTranslation("OpenVipHandler.Msg6", text);
						translation2 = LanguageMgr.GetTranslation("OpenVipHandler.Msg7", client.Player.PlayerCharacter.NickName);
					}
					clientByPlayerNickName.Out.imethod_2(clientByPlayerNickName.PlayerCharacter);
					clientByPlayerNickName.Out.SendMessage(eMessageType.Normal, translation2);
				}
				client.Player.AddExpVip(value);
				client.Out.SendMessage(eMessageType.Normal, translation);
			}
			return 0;
		}
	}
}
