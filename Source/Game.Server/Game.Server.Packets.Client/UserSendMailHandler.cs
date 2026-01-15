using System.Text;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(116, "发送邮件")]
	public class UserSendMailHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (client.Player.PlayerCharacter.Gold < 100)
			{
				return 1;
			}
			if (client.Player.IsLimitMail())
			{
				return 0;
			}
			string translateId = "UserSendMailHandler.Success";
			eMessageType type = eMessageType.Normal;
			GSPacketIn gSPacketIn = new GSPacketIn(116, client.Player.PlayerCharacter.ID);
			ItemInfo ıtemInfo = null;
			string text = packet.ReadString();
			string title = packet.ReadString();
			string content = packet.ReadString();
			bool flag = packet.ReadBoolean();
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			eBageType eBageType = (eBageType)packet.ReadByte();
			int num3 = packet.ReadInt();
			int num4 = packet.ReadInt();
			if (client.Player.IsLimitMoney(num2))
			{
				return 0;
			}
			int num5 = GameProperties.LimitLevel(0);
			if (num3 != -1 && client.Player.PlayerCharacter.Grade < num5)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("UserSendMailHandler.Msg4", num5));
				gSPacketIn.WriteBoolean(val: false);
				client.Out.SendTCP(gSPacketIn);
				return 0;
			}
			if (eBageType == eBageType.EquipBag && num3 < client.Player.EquipBag.BeginSlot)
			{
				gSPacketIn.WriteBoolean(val: false);
				client.Out.SendTCP(gSPacketIn);
				return 0;
			}
			if ((num2 != 0 || num3 != -1) && client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				gSPacketIn.WriteBoolean(val: false);
				client.Out.SendTCP(gSPacketIn);
				return 1;
			}
			ItemInfo ıtemInfo2 = null;
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				GamePlayer clientByPlayerNickName = WorldMgr.GetClientByPlayerNickName(text);
				PlayerInfo playerInfo = ((clientByPlayerNickName != null) ? clientByPlayerNickName.PlayerCharacter : playerBussiness.GetUserSingleByNickName(text));
				if (playerInfo != null && !string.IsNullOrEmpty(text))
				{
					if (playerInfo.Grade < num5)
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("UserSendMailHandler.Msg3", num5));
						gSPacketIn.WriteBoolean(val: false);
						client.Out.SendTCP(gSPacketIn);
						return 0;
					}
					if (playerInfo.NickName != client.Player.PlayerCharacter.NickName)
					{
						MailInfo mailInfo = new MailInfo();
						mailInfo.SenderID = client.Player.PlayerCharacter.ID;
						mailInfo.Sender = client.Player.PlayerCharacter.NickName;
						mailInfo.ReceiverID = playerInfo.ID;
						mailInfo.Receiver = playerInfo.NickName;
						mailInfo.IsExist = true;
						mailInfo.Gold = 0;
						mailInfo.Money = 0;
						mailInfo.Title = title;
						mailInfo.Content = content;
						StringBuilder stringBuilder = new StringBuilder();
						stringBuilder.Append(LanguageMgr.GetTranslation("UserSendMailHandler.AnnexRemark"));
						int num6 = 0;
						if (num3 != -1)
						{
							ıtemInfo = client.Player.GetItemAt(eBageType, num3);
							if (ıtemInfo == null)
							{
								client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("UserSendMailHandler.Msg1"));
								return 0;
							}
							if (!ıtemInfo.IsBinds)
							{
								if (ıtemInfo.Count < num4 || num4 < 0)
								{
									client.Out.SendMessage(type, LanguageMgr.GetTranslation("UserSendMailHandler.Msg2"));
									return 0;
								}
								if (client.Player.IsLimitCount(num4))
								{
									return 0;
								}
								ıtemInfo2 = ItemInfo.CloneFromTemplate(ıtemInfo.Template, ıtemInfo);
								ItemInfo ıtemInfo3 = ItemInfo.CloneFromTemplate(ıtemInfo.Template, ıtemInfo);
								ıtemInfo3.Count = num4;
								if (ıtemInfo3.ItemID == 0)
								{
									playerBussiness.AddGoods(ıtemInfo3);
								}
								mailInfo.String_0 = ıtemInfo3.Template.Name;
								mailInfo.Annex1 = ıtemInfo3.ItemID.ToString();
								num6++;
								stringBuilder.Append(num6);
								stringBuilder.Append("、");
								stringBuilder.Append(mailInfo.String_0);
								stringBuilder.Append("x");
								stringBuilder.Append(ıtemInfo3.Count);
								stringBuilder.Append(";");
							}
						}
						if (flag)
						{
							if (num2 <= 0 || (string.IsNullOrEmpty(mailInfo.Annex1) && string.IsNullOrEmpty(mailInfo.Annex2) && string.IsNullOrEmpty(mailInfo.Annex3) && string.IsNullOrEmpty(mailInfo.Annex4)))
							{
								return 1;
							}
							mailInfo.ValidDate = ((num == 1) ? 1 : 6);
							mailInfo.Type = 101;
							if (num2 > 0)
							{
								mailInfo.Money = num2;
								num6++;
								stringBuilder.Append(num6);
								stringBuilder.Append("、");
								stringBuilder.Append(LanguageMgr.GetTranslation("UserSendMailHandler.PayMoney"));
								stringBuilder.Append(num2);
								stringBuilder.Append(";");
							}
						}
						else
						{
							mailInfo.Type = 1;
							if (client.Player.PlayerCharacter.Money >= num2 && num2 > 0)
							{
								mailInfo.Money = num2;
								client.Player.RemoveMoney(num2);
								num6++;
								stringBuilder.Append(num6);
								stringBuilder.Append("、");
								stringBuilder.Append(LanguageMgr.GetTranslation("UserSendMailHandler.Money"));
								stringBuilder.Append(num2);
								stringBuilder.Append(";");
							}
						}
						if (stringBuilder.Length > 1)
						{
							mailInfo.AnnexRemark = stringBuilder.ToString();
						}
						if (playerBussiness.SendMail(mailInfo))
						{
							client.Player.RemoveGold(100);
							if (ıtemInfo != null)
							{
								int num7 = ıtemInfo.Count - num4;
								client.Player.RemoveItem(ıtemInfo);
								if (num7 > 0)
								{
									ıtemInfo2.Count = num7;
									client.Player.AddTemplate(ıtemInfo2, eBageType, num7, eGameView.RouletteTypeGet);
								}
							}
						}
						gSPacketIn.WriteBoolean(val: true);
						if (clientByPlayerNickName != null)
						{
							client.Player.Out.SendMailResponse(playerInfo.ID, eMailRespose.Receiver);
						}
						client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Send);
					}
					else
					{
						translateId = "UserSendMailHandler.Failed1";
						gSPacketIn.WriteBoolean(val: false);
					}
				}
				else
				{
					type = eMessageType.ERROR;
					translateId = "UserSendMailHandler.Failed2";
					gSPacketIn.WriteBoolean(val: false);
				}
			}
			client.Out.SendMessage(type, LanguageMgr.GetTranslation(translateId));
			client.Out.SendTCP(gSPacketIn);
			return 0;
		}
	}
}
