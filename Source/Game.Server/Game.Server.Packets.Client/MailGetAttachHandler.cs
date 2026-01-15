using System;
using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(113, "获取邮件到背包")]
	public class MailGetAttachHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			byte b = packet.ReadByte();
			List<int> list = new List<int>();
			List<string> list2 = new List<string>();
			int value = 0;
			int value2 = 0;
			int value3 = 0;
			string msg = "";
			eMessageType eMsg = eMessageType.Normal;
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(113, client.Player.PlayerCharacter.ID);
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				client.Player.LastAttachMail = DateTime.Now;
				MailInfo mailSingle = playerBussiness.GetMailSingle(client.Player.PlayerCharacter.ID, num);
				if (mailSingle != null)
				{
					bool result = true;
					int money = mailSingle.Money;
					if (mailSingle.Type > 100 && !client.Player.ActiveMoneyEnable(money))
					{
						return 0;
					}
					GamePlayer playerById = WorldMgr.GetPlayerById(mailSingle.ReceiverID);
					if (!mailSingle.IsRead)
					{
						mailSingle.IsRead = true;
						mailSingle.ValidDate = 72;
						mailSingle.SendTime = DateTime.Now;
					}
					if (result && (b == 0 || b == 1) && !string.IsNullOrEmpty(mailSingle.Annex1))
					{
						list.Add(1);
						list2.Add(mailSingle.Annex1);
						mailSingle.Annex1 = null;
					}
					if (result && (b == 0 || b == 2) && !string.IsNullOrEmpty(mailSingle.Annex2))
					{
						list.Add(2);
						list2.Add(mailSingle.Annex2);
						mailSingle.Annex2 = null;
					}
					if (result && (b == 0 || b == 3) && !string.IsNullOrEmpty(mailSingle.Annex3))
					{
						list.Add(3);
						list2.Add(mailSingle.Annex3);
						mailSingle.Annex3 = null;
					}
					if (result && (b == 0 || b == 4) && !string.IsNullOrEmpty(mailSingle.Annex4))
					{
						list.Add(4);
						list2.Add(mailSingle.Annex4);
						mailSingle.Annex4 = null;
					}
					if (result && (b == 0 || b == 5) && !string.IsNullOrEmpty(mailSingle.Annex5))
					{
						list.Add(5);
						list2.Add(mailSingle.Annex5);
						mailSingle.Annex5 = null;
					}
					if ((b == 0 || b == 6) && mailSingle.Gold > 0)
					{
						list.Add(6);
						value2 = mailSingle.Gold;
						mailSingle.Gold = 0;
					}
					if ((b == 0 || b == 7) && mailSingle.Type < 100 && mailSingle.Money > 0)
					{
						list.Add(7);
						value = mailSingle.Money;
						mailSingle.Money = 0;
					}
					if (mailSingle.Type > 100 && mailSingle.GiftToken > 0)
					{
						list.Add(8);
						value3 = mailSingle.GiftToken;
						mailSingle.GiftToken = 0;
					}
					if (mailSingle.Type > 100 && mailSingle.Money > 0)
					{
						mailSingle.Money = 0;
						msg = LanguageMgr.GetTranslation("MailGetAttachHandler.Deduct") + (string.IsNullOrEmpty(msg) ? LanguageMgr.GetTranslation("MailGetAttachHandler.Success") : msg);
					}
					if (playerBussiness.UpdateMail(mailSingle, money))
					{
						if (mailSingle.Type > 100 && money > 0)
						{
							client.Out.SendMailResponse(mailSingle.SenderID, eMailRespose.Receiver);
							client.Out.SendMailResponse(mailSingle.ReceiverID, eMailRespose.Send);
						}
						playerById.AddMoney(value);
						playerById.AddGold(value2);
						playerById.AddGiftToken(value3);
						foreach (string item in list2)
						{
							GetAnnex(item, client.Player, ref msg, ref result, ref eMsg);
						}
					}
					gSPacketIn.WriteInt(num);
					gSPacketIn.WriteInt(list.Count);
					foreach (int item2 in list)
					{
						gSPacketIn.WriteInt(item2);
					}
					client.Out.SendTCP(gSPacketIn);
					client.Out.SendMessage(eMsg, string.IsNullOrEmpty(msg) ? LanguageMgr.GetTranslation("MailGetAttachHandler.Success") : msg);
				}
				else
				{
					client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("MailGetAttachHandler.Falied"));
				}
			}
			return 0;
		}

		public bool GetAnnex(string value, GamePlayer player, ref string msg, ref bool result, ref eMessageType eMsg)
		{
			int itemID = int.Parse(value);
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				ItemInfo userItemSingle = playerBussiness.GetUserItemSingle(itemID);
				if (userItemSingle != null && player.AddTemplate(userItemSingle))
				{
					eMsg = eMessageType.Normal;
					return true;
				}
			}
			return false;
		}
	}
}
