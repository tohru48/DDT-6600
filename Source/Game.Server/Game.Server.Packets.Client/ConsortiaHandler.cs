using System;
using System.Collections.Generic;
using System.Text;
using Bussiness;
using Game.Base.Packets;
using Game.Server.Buffer;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(129, "公会聊天")]
	public class ConsortiaHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			bool flag = false;
			string msg = "Packet Error!";
			WorldMgr.GetAllPlayers();
			switch (num)
			{
			case 0:
			{
				if (client.Player.PlayerCharacter.ConsortiaID != 0)
				{
					return 0;
				}
				int num12 = packet.ReadInt();
				msg = "ConsortiaApplyLoginHandler.ADD_Failed";
				using (ConsortiaBussiness consortiaBussiness11 = new ConsortiaBussiness())
				{
					if (consortiaBussiness11.AddConsortiaApplyUsers(new ConsortiaApplyUserInfo
					{
						ApplyDate = DateTime.Now,
						ConsortiaID = num12,
						ConsortiaName = "",
						IsExist = true,
						Remark = "",
						UserID = client.Player.PlayerCharacter.ID,
						UserName = client.Player.PlayerCharacter.NickName
					}, ref msg))
					{
						msg = ((num12 != 0) ? "ConsortiaApplyLoginHandler.ADD_Success" : "ConsortiaApplyLoginHandler.DELETE_Success");
						flag = true;
					}
					else
					{
						client.Player.SendMessage("db.AddConsortia Error ");
					}
				}
				client.Out.sendConsortiaTryIn(num12, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 1:
			{
				if (client.Player.PlayerCharacter.ConsortiaID != 0)
				{
					return 0;
				}
				ConsortiaLevelInfo consortiaLevelInfo = ConsortiaExtraMgr.FindConsortiaLevelInfo(1);
				string text2 = packet.ReadString();
				int num15 = 0;
				int needGold = consortiaLevelInfo.NeedGold;
				int num16 = 5;
				msg = "ConsortiaCreateHandler.Failed";
				ConsortiaDutyInfo dutyInfo = new ConsortiaDutyInfo();
				if (!string.IsNullOrEmpty(text2) && client.Player.PlayerCharacter.Gold >= needGold && client.Player.PlayerCharacter.Grade >= num16)
				{
					using ConsortiaBussiness consortiaBussiness21 = new ConsortiaBussiness();
					ConsortiaInfo consortiaInfo8 = new ConsortiaInfo();
					consortiaInfo8.BuildDate = DateTime.Now;
					consortiaInfo8.CelebCount = 0;
					consortiaInfo8.ChairmanID = client.Player.PlayerCharacter.ID;
					consortiaInfo8.ChairmanName = client.Player.PlayerCharacter.NickName;
					consortiaInfo8.ConsortiaName = text2;
					consortiaInfo8.CreatorID = consortiaInfo8.ChairmanID;
					consortiaInfo8.CreatorName = consortiaInfo8.ChairmanName;
					consortiaInfo8.Description = "";
					consortiaInfo8.Honor = 0;
					consortiaInfo8.IP = "";
					consortiaInfo8.IsExist = true;
					consortiaInfo8.Level = consortiaLevelInfo.Level;
					consortiaInfo8.MaxCount = consortiaLevelInfo.Count;
					consortiaInfo8.Riches = consortiaLevelInfo.Riches;
					consortiaInfo8.Placard = "";
					consortiaInfo8.Port = 0;
					consortiaInfo8.Repute = 0;
					consortiaInfo8.Count = 1;
					if (consortiaBussiness21.AddConsortia(consortiaInfo8, ref msg, ref dutyInfo))
					{
						client.Player.PlayerCharacter.ConsortiaID = consortiaInfo8.ConsortiaID;
						client.Player.PlayerCharacter.ConsortiaName = consortiaInfo8.ConsortiaName;
						client.Player.PlayerCharacter.DutyLevel = dutyInfo.Level;
						client.Player.PlayerCharacter.DutyName = dutyInfo.DutyName;
						client.Player.PlayerCharacter.Right = dutyInfo.Right;
						client.Player.PlayerCharacter.ConsortiaLevel = consortiaLevelInfo.Level;
						client.Player.RemoveGold(needGold);
						msg = "ConsortiaCreateHandler.Success";
						flag = true;
						num15 = consortiaInfo8.ConsortiaID;
						GameServer.Instance.LoginServer.SendConsortiaCreate(num15, client.Player.PlayerCharacter.Offer, consortiaInfo8.ConsortiaName);
					}
					else
					{
						client.Player.SendMessage("db.AddConsortia Error ");
					}
				}
				client.Out.SendConsortiaCreate(text2, flag, num15, text2, LanguageMgr.GetTranslation(msg), dutyInfo.Level, dutyInfo.DutyName, dutyInfo.Right, client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 3:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				int num17 = packet.ReadInt();
				string nickName = "";
				msg = ((num17 == client.Player.PlayerCharacter.ID) ? "ConsortiaUserDeleteHandler.ExitFailed" : "ConsortiaUserDeleteHandler.KickFailed");
				using (ConsortiaBussiness consortiaBussiness24 = new ConsortiaBussiness())
				{
					if (consortiaBussiness24.DeleteConsortiaUser(client.Player.PlayerCharacter.ID, num17, client.Player.PlayerCharacter.ConsortiaID, ref msg, ref nickName))
					{
						msg = ((num17 == client.Player.PlayerCharacter.ID) ? "ConsortiaUserDeleteHandler.ExitSuccess" : "ConsortiaUserDeleteHandler.KickSuccess");
						int consortiaID3 = client.Player.PlayerCharacter.ConsortiaID;
						if (num17 == client.Player.PlayerCharacter.ID)
						{
							client.Player.ClearConsortia();
							client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
						}
						GameServer.Instance.LoginServer.SendConsortiaUserDelete(num17, consortiaID3, num17 != client.Player.PlayerCharacter.ID, nickName, client.Player.PlayerCharacter.NickName);
						flag = true;
					}
				}
				client.Out.sendConsortiaOut(num17, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 4:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				int num19 = packet.ReadInt();
				msg = "ConsortiaApplyLoginPassHandler.Failed";
				using (ConsortiaBussiness consortiaBussiness28 = new ConsortiaBussiness())
				{
					int consortiaRepute2 = 0;
					ConsortiaUserInfo consortiaUserInfo5 = new ConsortiaUserInfo();
					if (consortiaBussiness28.PassConsortiaApplyUsers(num19, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, client.Player.PlayerCharacter.ConsortiaID, ref msg, consortiaUserInfo5, ref consortiaRepute2))
					{
						msg = "ConsortiaApplyLoginPassHandler.Success";
						flag = true;
						if (consortiaUserInfo5.UserID != 0)
						{
							consortiaUserInfo5.ConsortiaID = client.Player.PlayerCharacter.ConsortiaID;
							consortiaUserInfo5.ConsortiaName = client.Player.PlayerCharacter.ConsortiaName;
							GameServer.Instance.LoginServer.SendConsortiaUserPass(client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, consortiaUserInfo5, isInvite: false, consortiaRepute2, consortiaUserInfo5.LoginName, client.Player.PlayerCharacter.FightPower, client.Player.PlayerCharacter.Offer);
						}
					}
				}
				client.Out.sendConsortiaTryInPass(num19, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 5:
			{
				int num11 = packet.ReadInt();
				msg = "ConsortiaApplyAllyDeleteHandler.Failed";
				using (ConsortiaBussiness consortiaBussiness10 = new ConsortiaBussiness())
				{
					if (consortiaBussiness10.DeleteConsortiaApplyUsers(num11, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.ConsortiaID, ref msg))
					{
						msg = ((client.Player.PlayerCharacter.ID == 0) ? "ConsortiaApplyAllyDeleteHandler.Success" : "ConsortiaApplyAllyDeleteHandler.Success2");
						flag = true;
					}
				}
				client.Out.sendConsortiaTryInDel(num11, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 6:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				int num7 = packet.ReadInt();
				if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
					return 1;
				}
				if (num7 >= 1 && client.Player.MoneyDirect(num7))
				{
					msg = "ConsortiaRichesOfferHandler.Failed";
					using (ConsortiaBussiness consortiaBussiness3 = new ConsortiaBussiness())
					{
						int riches2 = num7 / 2;
						if (consortiaBussiness3.ConsortiaRichAdd(client.Player.PlayerCharacter.ConsortiaID, ref riches2, 5, client.Player.PlayerCharacter.NickName))
						{
							flag = true;
							client.Player.AddRichesOffer(riches2);
							msg = "ConsortiaRichesOfferHandler.Successed";
							GameServer.Instance.LoginServer.SendConsortiaRichesOffer(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, riches2);
						}
					}
					client.Out.SendConsortiaRichesOffer(num7, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
					return 0;
				}
				return 1;
			}
			case 7:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 1;
				}
				bool state = packet.ReadBoolean();
				msg = "CONSORTIA_APPLY_STATE.Failed";
				using (ConsortiaBussiness consortiaBussiness18 = new ConsortiaBussiness())
				{
					if (consortiaBussiness18.UpdateConsotiaApplyState(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, state, ref msg))
					{
						msg = "CONSORTIA_APPLY_STATE.Success";
						flag = true;
					}
				}
				client.Out.sendConsortiaApplyStatusOut(state, flag, client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 9:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				int dutyID2 = packet.ReadInt();
				msg = "ConsortiaDutyDeleteHandler.Failed";
				using ConsortiaBussiness consortiaBussiness23 = new ConsortiaBussiness();
				if (consortiaBussiness23.DeleteConsortiaDuty(dutyID2, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.ConsortiaID, ref msg))
				{
					msg = "ConsortiaDutyDeleteHandler.Success";
					flag = true;
				}
				return 0;
			}
			case 11:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				string text4 = packet.ReadString();
				msg = "ConsortiaInviteAddHandler.Failed";
				if (string.IsNullOrEmpty(text4))
				{
					return 0;
				}
				using (ConsortiaBussiness consortiaBussiness27 = new ConsortiaBussiness())
				{
					ConsortiaInviteUserInfo consortiaInviteUserInfo = new ConsortiaInviteUserInfo();
					consortiaInviteUserInfo.ConsortiaID = client.Player.PlayerCharacter.ConsortiaID;
					consortiaInviteUserInfo.ConsortiaName = client.Player.PlayerCharacter.ConsortiaName;
					consortiaInviteUserInfo.InviteDate = DateTime.Now;
					consortiaInviteUserInfo.InviteID = client.Player.PlayerCharacter.ID;
					consortiaInviteUserInfo.InviteName = client.Player.PlayerCharacter.NickName;
					consortiaInviteUserInfo.IsExist = true;
					consortiaInviteUserInfo.Remark = "";
					consortiaInviteUserInfo.UserID = 0;
					consortiaInviteUserInfo.UserName = text4;
					if (consortiaBussiness27.AddConsortiaInviteUsers(consortiaInviteUserInfo, ref msg))
					{
						msg = "ConsortiaInviteAddHandler.Success";
						flag = true;
						GameServer.Instance.LoginServer.SendConsortiaInvite(consortiaInviteUserInfo.ID, consortiaInviteUserInfo.UserID, consortiaInviteUserInfo.UserName, consortiaInviteUserInfo.InviteID, consortiaInviteUserInfo.InviteName, consortiaInviteUserInfo.ConsortiaName, consortiaInviteUserInfo.ConsortiaID);
					}
				}
				client.Out.SendConsortiaInvite(text4, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 12:
			{
				if (client.Player.PlayerCharacter.ConsortiaID != 0)
				{
					return 0;
				}
				int num10 = packet.ReadInt();
				int consortiaID2 = 0;
				string consortiaName = "";
				msg = "ConsortiaInvitePassHandler.Failed";
				int tempID = 0;
				string tempName = "";
				using (ConsortiaBussiness consortiaBussiness9 = new ConsortiaBussiness())
				{
					int consortiaRepute = 0;
					ConsortiaUserInfo consortiaUserInfo2 = new ConsortiaUserInfo();
					if (consortiaBussiness9.PassConsortiaInviteUsers(num10, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, ref consortiaID2, ref consortiaName, ref msg, consortiaUserInfo2, ref tempID, ref tempName, ref consortiaRepute))
					{
						client.Player.PlayerCharacter.ConsortiaID = consortiaID2;
						client.Player.PlayerCharacter.ConsortiaName = consortiaName;
						client.Player.PlayerCharacter.DutyLevel = consortiaUserInfo2.Level;
						client.Player.PlayerCharacter.DutyName = consortiaUserInfo2.DutyName;
						client.Player.PlayerCharacter.Right = consortiaUserInfo2.Right;
						ConsortiaInfo consortiaInfo3 = ConsortiaMgr.FindConsortiaInfo(consortiaID2);
						if (consortiaInfo3 != null)
						{
							client.Player.PlayerCharacter.ConsortiaLevel = consortiaInfo3.Level;
						}
						msg = "ConsortiaInvitePassHandler.Success";
						flag = true;
						consortiaUserInfo2.UserID = client.Player.PlayerCharacter.ID;
						consortiaUserInfo2.UserName = client.Player.PlayerCharacter.NickName;
						consortiaUserInfo2.Grade = client.Player.PlayerCharacter.Grade;
						consortiaUserInfo2.Offer = client.Player.PlayerCharacter.Offer;
						consortiaUserInfo2.RichesOffer = client.Player.PlayerCharacter.RichesOffer;
						consortiaUserInfo2.RichesRob = client.Player.PlayerCharacter.RichesRob;
						consortiaUserInfo2.Win = client.Player.PlayerCharacter.Win;
						consortiaUserInfo2.Total = client.Player.PlayerCharacter.Total;
						consortiaUserInfo2.Escape = client.Player.PlayerCharacter.Escape;
						consortiaUserInfo2.ConsortiaID = consortiaID2;
						consortiaUserInfo2.ConsortiaName = consortiaName;
						GameServer.Instance.LoginServer.SendConsortiaUserPass(tempID, tempName, consortiaUserInfo2, isInvite: true, consortiaRepute, client.Player.PlayerCharacter.UserName, client.Player.PlayerCharacter.FightPower, client.Player.PlayerCharacter.Offer);
					}
				}
				client.Out.sendConsortiaInvitePass(num10, flag, consortiaID2, consortiaName, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 13:
			{
				int num14 = packet.ReadInt();
				msg = "ConsortiaInviteDeleteHandler.Failed";
				using (ConsortiaBussiness consortiaBussiness20 = new ConsortiaBussiness())
				{
					if (consortiaBussiness20.DeleteConsortiaInviteUsers(num14, client.Player.PlayerCharacter.ID))
					{
						msg = "ConsortiaInviteDeleteHandler.Success";
						flag = true;
					}
				}
				client.Out.sendConsortiaInviteDel(num14, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 14:
			{
				string text = packet.ReadString();
				if (Encoding.Default.GetByteCount(text) > 300)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ConsortiaDescriptionUpdateHandler.Long"));
					return 1;
				}
				msg = "ConsortiaDescriptionUpdateHandler.Failed";
				using (ConsortiaBussiness consortiaBussiness7 = new ConsortiaBussiness())
				{
					if (consortiaBussiness7.UpdateConsortiaDescription(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, text, ref msg))
					{
						msg = "ConsortiaDescriptionUpdateHandler.Success";
						flag = true;
					}
				}
				client.Out.sendConsortiaUpdateDescription(text, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 15:
			{
				string text3 = packet.ReadString();
				if (Encoding.Default.GetByteCount(text3) > 300)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ConsortiaPlacardUpdateHandler.Long"));
					return 1;
				}
				msg = "ConsortiaPlacardUpdateHandler.Failed";
				using (ConsortiaBussiness consortiaBussiness25 = new ConsortiaBussiness())
				{
					if (consortiaBussiness25.UpdateConsortiaPlacard(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, text3, ref msg))
					{
						msg = "ConsortiaPlacardUpdateHandler.Success";
						flag = true;
					}
				}
				client.Out.sendConsortiaUpdatePlacard(text3, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 18:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				int num13 = packet.ReadInt();
				bool flag3 = packet.ReadBoolean();
				msg = "ConsortiaUserGradeUpdateHandler.Failed";
				using (ConsortiaBussiness consortiaBussiness19 = new ConsortiaBussiness())
				{
					string tempUserName = "";
					ConsortiaDutyInfo info = new ConsortiaDutyInfo();
					if (consortiaBussiness19.UpdateConsortiaUserGrade(num13, client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, flag3, ref msg, ref info, ref tempUserName))
					{
						msg = "ConsortiaUserGradeUpdateHandler.Success";
						flag = true;
						GameServer.Instance.LoginServer.SendConsortiaDuty(info, flag3 ? 6 : 7, client.Player.PlayerCharacter.ConsortiaID, num13, tempUserName, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName);
					}
				}
				client.Out.SendConsortiaMemberGrade(num13, flag3, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 19:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				string text5 = packet.ReadString();
				msg = "ConsortiaChangeChairmanHandler.Failed";
				if (string.IsNullOrEmpty(text5))
				{
					msg = "ConsortiaChangeChairmanHandler.NoName";
				}
				else if (text5 == client.Player.PlayerCharacter.NickName)
				{
					msg = "ConsortiaChangeChairmanHandler.Self";
				}
				else
				{
					using ConsortiaBussiness consortiaBussiness29 = new ConsortiaBussiness();
					string tempUserName2 = "";
					int tempUserID = 0;
					ConsortiaDutyInfo info2 = new ConsortiaDutyInfo();
					if (consortiaBussiness29.UpdateConsortiaChairman(text5, client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg, ref info2, ref tempUserID, ref tempUserName2))
					{
						ConsortiaDutyInfo consortiaDutyInfo2 = new ConsortiaDutyInfo();
						consortiaDutyInfo2.Level = client.Player.PlayerCharacter.DutyLevel;
						consortiaDutyInfo2.DutyName = client.Player.PlayerCharacter.DutyName;
						consortiaDutyInfo2.Right = client.Player.PlayerCharacter.Right;
						msg = "ConsortiaChangeChairmanHandler.Success1";
						flag = true;
						GameServer.Instance.LoginServer.SendConsortiaDuty(consortiaDutyInfo2, 9, client.Player.PlayerCharacter.ConsortiaID, tempUserID, tempUserName2, 0, "");
						GameServer.Instance.LoginServer.SendConsortiaDuty(info2, 8, client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, 0, "");
					}
				}
				string translation = LanguageMgr.GetTranslation(msg);
				if (msg == "ConsortiaChangeChairmanHandler.Success1")
				{
					translation = translation + text5 + LanguageMgr.GetTranslation("ConsortiaChangeChairmanHandler.Success2");
				}
				client.Out.sendConsortiaChangeChairman(text5, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 20:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				if (client.Player.PlayerCharacter.IsBanChat)
				{
					client.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("ConsortiaChatHandler.IsBanChat"));
					return 1;
				}
				packet.ClientID = client.Player.PlayerCharacter.ID;
				packet.ReadByte();
				packet.ReadString();
				packet.ReadString();
				packet.WriteInt(client.Player.PlayerCharacter.ConsortiaID);
				GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
				foreach (GamePlayer gamePlayer in allPlayers)
				{
					if (gamePlayer.PlayerCharacter.ConsortiaID == client.Player.PlayerCharacter.ConsortiaID)
					{
						gamePlayer.Out.SendTCP(packet);
					}
				}
				GameServer.Instance.LoginServer.SendPacket(packet);
				return 0;
			}
			case 21:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				byte b2 = packet.ReadByte();
				byte level = 0;
				switch (b2)
				{
				case 1:
				{
					msg = "ConsortiaUpGradeHandler.Failed";
					using (ConsortiaBussiness consortiaBussiness13 = new ConsortiaBussiness())
					{
						ConsortiaInfo consortiaSingle = consortiaBussiness13.GetConsortiaSingle(client.Player.PlayerCharacter.ConsortiaID);
						if (consortiaSingle == null)
						{
							msg = "ConsortiaUpGradeHandler.NoConsortia";
							break;
						}
						ConsortiaLevelInfo consortiaLevelInfo = ConsortiaExtraMgr.FindConsortiaLevelInfo(consortiaSingle.Level + 1);
						if (consortiaLevelInfo == null)
						{
							msg = "ConsortiaUpGradeHandler.NoUpGrade";
							break;
						}
						if (consortiaLevelInfo.NeedGold > client.Player.PlayerCharacter.Gold)
						{
							msg = "ConsortiaUpGradeHandler.NoGold";
							break;
						}
						using ConsortiaBussiness consortiaBussiness14 = new ConsortiaBussiness();
						if (consortiaBussiness14.UpGradeConsortia(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg))
						{
							consortiaSingle.Level++;
							client.Player.RemoveGold(consortiaLevelInfo.NeedGold);
							GameServer.Instance.LoginServer.SendConsortiaUpGrade(consortiaSingle);
							msg = "ConsortiaUpGradeHandler.Success";
							flag = true;
							level = (byte)consortiaSingle.Level;
						}
					}
					break;
				}
				case 2:
				{
					msg = "ConsortiaStoreUpGradeHandler.Failed";
					ConsortiaInfo consortiaInfo7 = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
					if (consortiaInfo7 == null)
					{
						msg = "ConsortiaStoreUpGradeHandler.NoConsortia";
						break;
					}
					using (ConsortiaBussiness consortiaBussiness17 = new ConsortiaBussiness())
					{
						if (consortiaBussiness17.UpGradeStoreConsortia(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg))
						{
							consortiaInfo7.StoreLevel++;
							GameServer.Instance.LoginServer.SendConsortiaStoreUpGrade(consortiaInfo7);
							msg = "ConsortiaStoreUpGradeHandler.Success";
							flag = true;
							level = (byte)consortiaInfo7.StoreLevel;
						}
					}
					break;
				}
				case 3:
				{
					msg = "ConsortiaShopUpGradeHandler.Failed";
					ConsortiaInfo consortiaInfo5 = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
					if (consortiaInfo5 == null)
					{
						msg = "ConsortiaShopUpGradeHandler.NoConsortia";
						break;
					}
					using (ConsortiaBussiness consortiaBussiness15 = new ConsortiaBussiness())
					{
						if (consortiaBussiness15.UpGradeShopConsortia(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg))
						{
							consortiaInfo5.ShopLevel++;
							GameServer.Instance.LoginServer.SendConsortiaShopUpGrade(consortiaInfo5);
							msg = "ConsortiaShopUpGradeHandler.Success";
							flag = true;
							level = (byte)consortiaInfo5.ShopLevel;
						}
					}
					break;
				}
				case 4:
				{
					msg = "ConsortiaSmithUpGradeHandler.Failed";
					ConsortiaInfo consortiaInfo6 = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
					if (consortiaInfo6 == null)
					{
						msg = "ConsortiaSmithUpGradeHandler.NoConsortia";
						break;
					}
					using (ConsortiaBussiness consortiaBussiness16 = new ConsortiaBussiness())
					{
						if (consortiaBussiness16.UpGradeSmithConsortia(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg))
						{
							consortiaInfo6.SmithLevel++;
							GameServer.Instance.LoginServer.SendConsortiaSmithUpGrade(consortiaInfo6);
							msg = "ConsortiaSmithUpGradeHandler.Success";
							flag = true;
							level = (byte)consortiaInfo6.SmithLevel;
						}
					}
					break;
				}
				case 5:
				{
					msg = "ConsortiaBufferUpGradeHandler.Failed";
					ConsortiaInfo consortiaInfo4 = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
					if (consortiaInfo4 == null)
					{
						msg = "ConsortiaUpGradeHandler.NoConsortia";
						break;
					}
					using (ConsortiaBussiness consortiaBussiness12 = new ConsortiaBussiness())
					{
						if (consortiaBussiness12.UpGradeSkillConsortia(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, ref msg))
						{
							consortiaInfo4.SkillLevel++;
							GameServer.Instance.LoginServer.SendConsortiaKillUpGrade(consortiaInfo4);
							msg = "ConsortiaBufferUpGradeHandler.Success";
							flag = true;
							level = (byte)consortiaInfo4.SkillLevel;
						}
					}
					break;
				}
				}
				client.Out.SendConsortiaLevelUp(b2, level, flag, LanguageMgr.GetTranslation(msg), client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 24:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				int item = 0;
				int item2 = 0;
				int item3 = 0;
				int item4 = 0;
				int item5 = 0;
				int item6 = 0;
				int item7 = 0;
				msg = "ConsortiaEquipControlHandler.Fail";
				ConsortiaEquipControlInfo consortiaEquipControlInfo = new ConsortiaEquipControlInfo();
				consortiaEquipControlInfo.ConsortiaID = client.Player.PlayerCharacter.ConsortiaID;
				using (ConsortiaBussiness consortiaBussiness8 = new ConsortiaBussiness())
				{
					for (int j = 0; j < 5; j++)
					{
						consortiaEquipControlInfo.Riches = packet.ReadInt();
						consortiaEquipControlInfo.Type = 1;
						consortiaEquipControlInfo.Level = j + 1;
						consortiaBussiness8.AddAndUpdateConsortiaEuqipControl(consortiaEquipControlInfo, client.Player.PlayerCharacter.ID, ref msg);
						switch (j)
						{
						case 0:
							item = consortiaEquipControlInfo.Riches;
							break;
						case 1:
							item2 = consortiaEquipControlInfo.Riches;
							break;
						case 2:
							item3 = consortiaEquipControlInfo.Riches;
							break;
						case 3:
							item4 = consortiaEquipControlInfo.Riches;
							break;
						case 4:
							item5 = consortiaEquipControlInfo.Riches;
							break;
						}
					}
					consortiaEquipControlInfo.Riches = packet.ReadInt();
					consortiaEquipControlInfo.Type = 2;
					consortiaEquipControlInfo.Level = 0;
					item6 = consortiaEquipControlInfo.Riches;
					consortiaBussiness8.AddAndUpdateConsortiaEuqipControl(consortiaEquipControlInfo, client.Player.PlayerCharacter.ID, ref msg);
					consortiaEquipControlInfo.Riches = packet.ReadInt();
					consortiaEquipControlInfo.Type = 3;
					consortiaEquipControlInfo.Level = 0;
					item7 = consortiaEquipControlInfo.Riches;
					consortiaBussiness8.AddAndUpdateConsortiaEuqipControl(consortiaEquipControlInfo, client.Player.PlayerCharacter.ID, ref msg);
					msg = "ConsortiaEquipControlHandler.Success";
					flag = true;
				}
				List<int> list = new List<int>();
				list.Add(item);
				list.Add(item2);
				list.Add(item3);
				list.Add(item4);
				list.Add(item5);
				list.Add(item6);
				list.Add(item7);
				List<int> riches5 = list;
				client.Out.sendConsortiaEquipConstrol(flag, riches5, client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 26:
			{
				packet.ReadBoolean();
				int id = packet.ReadInt();
				int num3 = packet.ReadInt();
				int num4 = packet.ReadInt();
				if (num3 < 0)
				{
					num3 = 1;
				}
				ConsortiaBufferTempInfo consortiaBufferTempInfo = ConsortiaExtraMgr.FindConsortiaBuffInfo(id);
				if (consortiaBufferTempInfo == null)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Consortia.Msg1"));
					return 0;
				}
				int num5 = 0;
				bool flag2 = false;
				int num6 = num4;
				if (num6 == 1)
				{
					num5 = num3 * consortiaBufferTempInfo.riches;
					if (client.Player.PlayerCharacter.Offer >= num5)
					{
						flag2 = true;
					}
				}
				else
				{
					num5 = num3 * consortiaBufferTempInfo.metal;
					if (client.Player.PlayerCharacter.DDTMoney >= num5)
					{
						flag2 = true;
					}
				}
				int validMinutes = 1440 * num3;
				ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
				if (consortiaInfo == null || !flag2)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Consortia.Msg6"));
					return 0;
				}
				if (consortiaBufferTempInfo.level <= consortiaInfo.Level)
				{
					switch (consortiaBufferTempInfo.group)
					{
					case 1:
						BufferList.CreatePayBuffer(101, consortiaBufferTempInfo.value, validMinutes, id)?.Start(client.Player);
						break;
					case 6:
						BufferList.CreatePayBuffer(106, consortiaBufferTempInfo.value, validMinutes, id)?.Start(client.Player);
						break;
					case 8:
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Consortia.Msg2"));
						return 0;
					case 11:
						BufferList.CreatePayBuffer(111, consortiaBufferTempInfo.value, validMinutes, id)?.Start(client.Player);
						break;
					case 12:
						BufferList.CreatePayBuffer(112, consortiaBufferTempInfo.value, validMinutes, id)?.Start(client.Player);
						break;
					default:
					{
						using (PlayerBussiness playerBussiness = new PlayerBussiness())
						{
							ConsortiaUserInfo[] allMemberByConsortia = playerBussiness.GetAllMemberByConsortia(client.Player.PlayerCharacter.ConsortiaID);
							AbstractBuffer abstractBuffer = null;
							switch (consortiaBufferTempInfo.group)
							{
							case 2:
								abstractBuffer = BufferList.CreatePayBuffer(102, consortiaBufferTempInfo.value, validMinutes, id);
								break;
							case 4:
								abstractBuffer = BufferList.CreatePayBuffer(104, consortiaBufferTempInfo.value, validMinutes, id);
								break;
							case 5:
								abstractBuffer = BufferList.CreatePayBuffer(105, consortiaBufferTempInfo.value, validMinutes, id);
								break;
							case 7:
								abstractBuffer = BufferList.CreatePayBuffer(107, consortiaBufferTempInfo.value, validMinutes, id);
								break;
							case 9:
								abstractBuffer = BufferList.CreatePayBuffer(109, consortiaBufferTempInfo.value, validMinutes, id);
								break;
							case 10:
								abstractBuffer = BufferList.CreatePayBuffer(110, consortiaBufferTempInfo.value, validMinutes, id);
								break;
							}
							ConsortiaUserInfo[] array = allMemberByConsortia;
							foreach (ConsortiaUserInfo consortiaUserInfo in array)
							{
								GamePlayer playerById = WorldMgr.GetPlayerById(consortiaUserInfo.UserID);
								if (playerById != null)
								{
									abstractBuffer?.Start(playerById);
									if (playerById != client.Player)
									{
										playerById.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Consortia.Msg3"));
									}
								}
							}
							if (abstractBuffer != null)
							{
								ConsortiaBufferInfo consortiaBufferInfo = playerBussiness.GetUserConsortiaBufferSingle(consortiaBufferTempInfo.id);
								if (consortiaBufferInfo == null)
								{
									consortiaBufferInfo = new ConsortiaBufferInfo();
									consortiaBufferInfo.ConsortiaID = client.Player.PlayerCharacter.ConsortiaID;
									consortiaBufferInfo.IsOpen = true;
									consortiaBufferInfo.BufferID = consortiaBufferTempInfo.id;
									consortiaBufferInfo.Type = abstractBuffer.Info.Type;
									consortiaBufferInfo.Value = abstractBuffer.Info.Value;
									consortiaBufferInfo.ValidDate = abstractBuffer.Info.ValidDate;
									consortiaBufferInfo.BeginDate = abstractBuffer.Info.BeginDate;
								}
								else
								{
									consortiaBufferInfo.BufferID = consortiaBufferTempInfo.id;
									consortiaBufferInfo.Value = abstractBuffer.Info.Value;
									consortiaBufferInfo.ValidDate += abstractBuffer.Info.ValidDate;
								}
								playerBussiness.SaveConsortiaBuffer(consortiaBufferInfo);
							}
						}
						break;
					}
					case 3:
						BufferList.CreatePayBuffer(103, consortiaBufferTempInfo.value, validMinutes, id)?.Start(client.Player);
						break;
					}
					if (num4 == 1)
					{
						if (consortiaBufferTempInfo.type == 1)
						{
							using ConsortiaBussiness consortiaBussiness2 = new ConsortiaBussiness();
							int riches = num5;
							consortiaBussiness2.ConsortiaRichRemove(client.Player.PlayerCharacter.ConsortiaID, ref riches);
						}
						else
						{
							client.Player.RemoveOffer(num5);
						}
					}
					else
					{
						client.Player.RemoveGiftToken(num5);
					}
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Consortia.Msg4"));
					return 0;
				}
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Consortia.Msg5"));
				return 0;
			}
			case 28:
			{
				int num18 = packet.ReadInt();
				msg = "BuyBadgeHandler.Fail";
				int validDate = 30;
				string badgeBuyTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
				ConsortiaInfo consortiaInfo10 = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
				using (ConsortiaBussiness consortiaBussiness26 = new ConsortiaBussiness())
				{
					consortiaInfo10.BadgeID = num18;
					consortiaInfo10.ValidDate = validDate;
					consortiaInfo10.BadgeBuyTime = badgeBuyTime;
					if (consortiaBussiness26.BuyBadge(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, consortiaInfo10, ref msg))
					{
						msg = "BuyBadgeHandler.Success";
						flag = true;
					}
				}
				if (flag)
				{
					using PlayerBussiness playerBussiness3 = new PlayerBussiness();
					ConsortiaUserInfo[] allMemberByConsortia3 = playerBussiness3.GetAllMemberByConsortia(client.Player.PlayerCharacter.ConsortiaID);
					ConsortiaUserInfo[] array = allMemberByConsortia3;
					foreach (ConsortiaUserInfo consortiaUserInfo4 in array)
					{
						GamePlayer playerById2 = WorldMgr.GetPlayerById(consortiaUserInfo4.UserID);
						if (playerById2 != null && playerById2.PlayerId != client.Player.PlayerCharacter.ID)
						{
							playerById2.UpdateBadgeId(num18);
							playerById2.SendMessage(LanguageMgr.GetTranslation("Consortia.Msg7"));
							playerById2.UpdateProperties();
						}
					}
				}
				client.Player.SendMessage(msg);
				client.Out.sendBuyBadge(num18, validDate, flag, badgeBuyTime, client.Player.PlayerCharacter.ID);
				client.Player.UpdateBadgeId(num18);
				client.Player.UpdateProperties();
				return 0;
			}
			case 29:
			{
				string title = packet.ReadString();
				string content = packet.ReadString();
				msg = "ConsortiaRichiUpdateHandler.Failed";
				ConsortiaInfo consortiaInfo9 = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
				using (PlayerBussiness playerBussiness2 = new PlayerBussiness())
				{
					ConsortiaUserInfo[] allMemberByConsortia2 = playerBussiness2.GetAllMemberByConsortia(client.Player.PlayerCharacter.ConsortiaID);
					MailInfo mailInfo = new MailInfo();
					ConsortiaUserInfo[] array = allMemberByConsortia2;
					foreach (ConsortiaUserInfo consortiaUserInfo3 in array)
					{
						mailInfo.SenderID = client.Player.PlayerCharacter.ID;
						mailInfo.Sender = "Chủ Guild " + consortiaInfo9.ConsortiaName;
						mailInfo.ReceiverID = consortiaUserInfo3.UserID;
						mailInfo.Receiver = consortiaUserInfo3.UserName;
						mailInfo.Title = title;
						mailInfo.Content = content;
						mailInfo.Type = 59;
						if (consortiaUserInfo3.UserID != client.Player.PlayerCharacter.ID && playerBussiness2.SendMail(mailInfo))
						{
							msg = "ConsortiaRichiUpdateHandler.Success";
							flag = true;
							if (consortiaUserInfo3.State != 0)
							{
								client.Player.Out.SendMailResponse(consortiaUserInfo3.UserID, eMailRespose.Receiver);
							}
							client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Send);
						}
						if (!flag)
						{
							client.Player.SendMessage("SendMail Error!");
							break;
						}
					}
				}
				if (flag)
				{
					using ConsortiaBussiness consortiaBussiness22 = new ConsortiaBussiness();
					consortiaBussiness22.UpdateConsortiaRiches(client.Player.PlayerCharacter.ConsortiaID, client.Player.PlayerCharacter.ID, 1000, ref msg);
				}
				client.Out.SendConsortiaMail(flag, client.Player.PlayerCharacter.ID);
				return 0;
			}
			case 30:
			{
				byte b = packet.ReadByte();
				int num8 = packet.ReadInt();
				int consortiaID = client.Player.PlayerCharacter.ConsortiaID;
				ConsortiaInfo consortiaInfo2 = ConsortiaBossMgr.GetConsortiaById(consortiaID);
				if (consortiaInfo2 == null || consortiaInfo2.LastOpenBoss.Date < DateTime.Now.Date)
				{
					using ConsortiaBussiness consortiaBussiness4 = new ConsortiaBussiness();
					consortiaInfo2 = consortiaBussiness4.GetConsortiaSingle(consortiaID);
				}
				if (consortiaInfo2 == null)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Consortia.Msg8"));
					return 0;
				}
				if (consortiaInfo2.Level < 3)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Consortia.Msg9"));
					return 0;
				}
				int num9 = ConsortiaMgr.FindConsortiaBossMaxLevel(0, consortiaInfo2);
				ConsortiaBossConfigInfo consortiaBossConfigInfo = ConsortiaMgr.FindConsortiaBossConfig(num9);
				if (consortiaBossConfigInfo == null || (consortiaBossConfigInfo.Level != num8 && num8 > 1))
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Consortia.Msg10"));
					return 0;
				}
				switch (b)
				{
				case 0:
				{
					if (consortiaInfo2.Riches < consortiaBossConfigInfo.CostRich)
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("Consortia.Msg11"));
						return 0;
					}
					consortiaInfo2.bossState = 1;
					consortiaInfo2.endTime = DateTime.Now.AddMinutes(20.0);
					consortiaInfo2.LastOpenBoss = DateTime.Now;
					using (ConsortiaBussiness consortiaBussiness6 = new ConsortiaBussiness())
					{
						int riches4 = consortiaBossConfigInfo.CostRich;
						if (consortiaBussiness6.ConsortiaRichRemove(client.Player.PlayerCharacter.ConsortiaID, ref riches4))
						{
							consortiaInfo2.Riches = riches4;
						}
					}
					ConsortiaBossMgr.CreateBoss(consortiaInfo2, consortiaBossConfigInfo.NpcID);
					return 0;
				}
				case 2:
				{
					if (consortiaInfo2.Riches < consortiaBossConfigInfo.ProlongRich)
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("Consortia.Msg12"));
						return 0;
					}
					using (ConsortiaBussiness consortiaBussiness5 = new ConsortiaBussiness())
					{
						int riches3 = consortiaBossConfigInfo.ProlongRich;
						if (consortiaBussiness5.ConsortiaRichRemove(client.Player.PlayerCharacter.ConsortiaID, ref riches3))
						{
							consortiaInfo2.Riches = riches3;
						}
					}
					ConsortiaBossMgr.ExtendAvailable(consortiaID, consortiaInfo2.Riches);
					return 0;
				}
				default:
					if (ConsortiaBossMgr.GetConsortiaExit(consortiaID))
					{
						ConsortiaBossMgr.reload(consortiaID);
						return 0;
					}
					consortiaInfo2.bossState = 0;
					consortiaInfo2.endTime = DateTime.Now;
					consortiaInfo2.extendAvailableNum = 3;
					consortiaInfo2.callBossLevel = num9;
					ConsortiaBossMgr.AddConsortia(consortiaInfo2);
					return 0;
				}
			}
			case 10:
			{
				if (client.Player.PlayerCharacter.ConsortiaID == 0)
				{
					return 0;
				}
				int dutyID = packet.ReadInt();
				int num2 = packet.ReadByte();
				msg = "ConsortiaDutyUpdateHandler.Failed";
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				ConsortiaDutyInfo consortiaDutyInfo = new ConsortiaDutyInfo();
				consortiaDutyInfo.ConsortiaID = client.Player.PlayerCharacter.ConsortiaID;
				consortiaDutyInfo.DutyID = dutyID;
				consortiaDutyInfo.IsExist = true;
				consortiaDutyInfo.DutyName = "";
				switch (num2)
				{
				case 1:
					return 1;
				case 2:
					consortiaDutyInfo.DutyName = packet.ReadString();
					if (string.IsNullOrEmpty(consortiaDutyInfo.DutyName) || Encoding.Default.GetByteCount(consortiaDutyInfo.DutyName) > 10)
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ConsortiaDutyUpdateHandler.Long"));
						return 1;
					}
					consortiaDutyInfo.Right = packet.ReadInt();
					break;
				}
				if (consortiaBussiness.UpdateConsortiaDuty(consortiaDutyInfo, client.Player.PlayerCharacter.ID, num2, ref msg))
				{
					dutyID = consortiaDutyInfo.DutyID;
					msg = "ConsortiaDutyUpdateHandler.Success";
					flag = true;
					GameServer.Instance.LoginServer.SendConsortiaDuty(consortiaDutyInfo, num2, client.Player.PlayerCharacter.ConsortiaID);
				}
				return 0;
			}
			default:
				Console.WriteLine("ConsortiaPackageType." + (ConsortiaPackageType)num);
				return 0;
			}
		}
	}
}
