using System;
using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(84, "场景用户离开")]
	public class ActivityPackageHandler : IPacketHandler
	{
		private readonly int[] int_0;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int ıD = client.Player.PlayerCharacter.ID;
			ActiveSystemInfo ınfo = client.Player.Actives.Info;
			switch (num)
			{
			case 1:
			{
				if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
				{
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
					return 0;
				}
				if (DateTime.Compare(client.Player.LastOpenGrowthPackage.AddMilliseconds(500.0), DateTime.Now) > 0)
				{
					client.Player.Out.SendGrowthPackageUpadte(client.Player.PlayerCharacter.ID, ınfo.AvailTime);
					return 0;
				}
				int availTime = ınfo.AvailTime;
				int promotePackagePrice = GameProperties.PromotePackagePrice;
				string translation = LanguageMgr.GetTranslation("UserBuyItemHandler.Success");
				List<ItemInfo> list3 = new List<ItemInfo>();
				int num6 = (client.Player.PlayerCharacter.Sex ? 1 : 2);
				int num7 = packet.ReadInt();
				switch (num7)
				{
				case 1:
					if (!client.Player.MoneyDirect(promotePackagePrice))
					{
						break;
					}
					if (method_0(client.Player.PlayerCharacter.Grade, availTime))
					{
						List<ActivitySystemItemInfo> growthPackage2 = ActiveMgr.GetGrowthPackage(availTime);
						foreach (ActivitySystemItemInfo item in growthPackage2)
						{
							ItemTemplateInfo ıtemTemplateInfo3 = ItemMgr.FindItemTemplate(item.TemplateID);
							if (ıtemTemplateInfo3 != null && (ıtemTemplateInfo3.NeedSex == 0 || ıtemTemplateInfo3.NeedSex == num6))
							{
								ItemInfo ıtemInfo3 = ItemInfo.CreateFromTemplate(ıtemTemplateInfo3, item.Count, 102);
								ıtemInfo3.Count = item.Count;
								ıtemInfo3.IsBinds = item.IsBind;
								ıtemInfo3.ValidDate = item.ValidDate;
								ıtemInfo3.StrengthenLevel = item.StrengthLevel;
								ıtemInfo3.AttackCompose = item.AttackCompose;
								ıtemInfo3.DefendCompose = item.DefendCompose;
								ıtemInfo3.AgilityCompose = item.AgilityCompose;
								ıtemInfo3.LuckCompose = item.LuckCompose;
								list3.Add(ıtemInfo3);
							}
						}
						break;
					}
					client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ActivityPackageHandler.Msg1"));
					return 0;
				case 2:
				{
					if (!method_0(client.Player.PlayerCharacter.Grade, availTime))
					{
						client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ActivityPackageHandler.Msg1"));
						return 0;
					}
					translation = LanguageMgr.GetTranslation("ActivityPackageHandler.Msg3");
					List<ActivitySystemItemInfo> growthPackage = ActiveMgr.GetGrowthPackage(availTime);
					foreach (ActivitySystemItemInfo item2 in growthPackage)
					{
						ItemTemplateInfo ıtemTemplateInfo2 = ItemMgr.FindItemTemplate(item2.TemplateID);
						if (ıtemTemplateInfo2 != null && (ıtemTemplateInfo2.NeedSex == 0 || ıtemTemplateInfo2.NeedSex == num6))
						{
							ItemInfo ıtemInfo2 = ItemInfo.CreateFromTemplate(ıtemTemplateInfo2, item2.Count, 102);
							ıtemInfo2.Count = item2.Count;
							ıtemInfo2.IsBinds = item2.IsBind;
							ıtemInfo2.ValidDate = item2.ValidDate;
							ıtemInfo2.StrengthenLevel = item2.StrengthLevel;
							ıtemInfo2.AttackCompose = item2.AttackCompose;
							ıtemInfo2.DefendCompose = item2.DefendCompose;
							ıtemInfo2.AgilityCompose = item2.AgilityCompose;
							ıtemInfo2.LuckCompose = item2.LuckCompose;
							list3.Add(ıtemInfo2);
						}
					}
					break;
				}
				default:
					Console.WriteLine("GrowthPackageType.{0}", (GrowthPackageType)num7);
					break;
				}
				if (list3.Count > 0)
				{
					ınfo.AvailTime++;
					WorldEventMgr.SendItemsToMail(list3, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, $"Qùa trưởng thành cấp {int_0[availTime]} ");
				}
				else
				{
					translation = LanguageMgr.GetTranslation("ActivityPackageHandler.Msg2");
				}
				client.Player.Out.SendGrowthPackageUpadte(client.Player.PlayerCharacter.ID, ınfo.AvailTime);
				client.Out.SendMessage(eMessageType.Normal, translation);
				client.Player.LastOpenGrowthPackage = DateTime.Now;
				return 0;
			}
			case 2:
			{
				UserChickActiveInfo chickActiveData = client.Player.Actives.GetChickActiveData();
				int[] array = new int[10] { 1, 2, 4, 8, 16, 32, 64, 128, 256, 512 };
				int[] array2 = new int[10] { 5, 10, 25, 30, 40, 45, 48, 50, 55, 60 };
				int num2 = packet.ReadInt();
				GSPacketIn gSPacketIn = new GSPacketIn(84, client.Player.PlayerCharacter.ID);
				gSPacketIn.WriteInt(2);
				switch (num2)
				{
				case 1:
				{
					string text = packet.ReadString();
					if (text.Length != 14 || chickActiveData.IsKeyOpened != 0)
					{
						return 0;
					}
					using PlayerBussiness playerBussiness = new PlayerBussiness();
					switch (playerBussiness.ActiveChickCode(client.Player.PlayerCharacter.ID, text))
					{
					case 0:
						chickActiveData.Active((client.Player.PlayerCharacter.Grade <= 15) ? 1 : 2);
						client.Player.Actives.SaveChickActiveData(chickActiveData);
						client.Player.Actives.SendUpdateChickActivation();
						client.Player.SendMessage(LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.Success"));
						break;
					case 1:
						client.Player.SendMessage(LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.NotExit"));
						break;
					case 2:
						client.Player.SendMessage(LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.IsUsed"));
						break;
					}
					return 0;
				}
				case 3:
					if (chickActiveData != null)
					{
						gSPacketIn.WriteInt(1);
						gSPacketIn.WriteInt(chickActiveData.IsKeyOpened);
						gSPacketIn.WriteInt(1);
						gSPacketIn.WriteDateTime(chickActiveData.KeyOpenedTime);
						gSPacketIn.WriteInt(chickActiveData.KeyOpenedType);
						PacketIn packetIn = gSPacketIn;
						int val = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Monday) ? 1 : 0);
						packetIn.WriteInt(val);
						PacketIn packetIn2 = gSPacketIn;
						int val2 = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Tuesday) ? 1 : 0);
						packetIn2.WriteInt(val2);
						PacketIn packetIn3 = gSPacketIn;
						int val3 = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Wednesday) ? 1 : 0);
						packetIn3.WriteInt(val3);
						PacketIn packetIn4 = gSPacketIn;
						int val4 = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Thursday) ? 1 : 0);
						packetIn4.WriteInt(val4);
						PacketIn packetIn5 = gSPacketIn;
						int val5 = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Friday) ? 1 : 0);
						packetIn5.WriteInt(val5);
						PacketIn packetIn6 = gSPacketIn;
						int val6 = ((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Saturday) ? 1 : 0);
						packetIn6.WriteInt(val6);
						gSPacketIn.WriteInt((chickActiveData.EveryDay.Day >= DateTime.Now.Day || DateTime.Now.DayOfWeek != DayOfWeek.Sunday) ? 1 : 0);
						gSPacketIn.WriteInt((chickActiveData.AfterThreeDays.Day >= DateTime.Now.Day || !chickActiveData.OnThreeDay(DateTime.Now)) ? 1 : 0);
						gSPacketIn.WriteInt((chickActiveData.AfterThreeDays.Day >= DateTime.Now.Day || !chickActiveData.OnThreeDay(DateTime.Now)) ? 1 : 0);
						gSPacketIn.WriteInt((chickActiveData.AfterThreeDays.Day >= DateTime.Now.Day || !chickActiveData.OnThreeDay(DateTime.Now)) ? 1 : 0);
						PacketIn packetIn7 = gSPacketIn;
						int val7 = ((!(chickActiveData.Weekly < chickActiveData.StartOfWeek(DateTime.Now, DayOfWeek.Saturday)) || DateTime.Now.DayOfWeek != DayOfWeek.Saturday) ? 1 : 0);
						packetIn7.WriteInt(val7);
						gSPacketIn.WriteInt(chickActiveData.CurrentLvAward);
						client.Player.SendTCP(gSPacketIn);
						return 0;
					}
					return 0;
				default:
					Console.WriteLine("ChickActivationType.{0}", (ChickActivationType)num2);
					return 0;
				case 2:
				{
					int num3 = packet.ReadInt();
					int num4 = packet.ReadInt();
					if (chickActiveData.IsKeyOpened != 1 || !(chickActiveData.KeyOpenedTime.AddDays(60.0).Date >= DateTime.Now.Date))
					{
						client.Player.SendMessage(LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.NotActive"));
						return 0;
					}
					List<ActivitySystemItemInfo> list = null;
					int num5 = (client.Player.PlayerCharacter.Sex ? 1 : 2);
					string title = "";
					string message = "";
					if (num3 <= 7 && chickActiveData.EveryDay.Day < DateTime.Now.Day)
					{
						chickActiveData.EveryDay = DateTime.Now;
						list = ActiveMgr.FindChickActivePakage((chickActiveData.KeyOpenedType != 2) ? 1 : 101);
						title = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.DaylyAward.Title");
						message = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.DaylyAward.Msg");
					}
					else if (num3 <= 10 && chickActiveData.AfterThreeDays.Day < DateTime.Now.Day && chickActiveData.OnThreeDay(DateTime.Now))
					{
						chickActiveData.AfterThreeDays = DateTime.Now;
						list = ActiveMgr.FindChickActivePakage((chickActiveData.KeyOpenedType == 2) ? 102 : 2);
						title = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.WeekenAward.Title");
						message = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.WeekenAward.Msg");
					}
					else if (num3 == 11 && chickActiveData.Weekly < chickActiveData.StartOfWeek(DateTime.Now, DayOfWeek.Saturday) && DateTime.Now.DayOfWeek == DayOfWeek.Saturday)
					{
						chickActiveData.Weekly = chickActiveData.StartOfWeek(DateTime.Now, DayOfWeek.Saturday);
						list = ActiveMgr.FindChickActivePakage((chickActiveData.KeyOpenedType == 2) ? 103 : 3);
						title = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.WeeklyAward.Title");
						message = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.WeeklyAward.Msg");
					}
					else if (num3 == 12 && array[num4 - 1] > chickActiveData.CurrentLvAward && client.Player.PlayerCharacter.Grade >= array2[num4 - 1] && chickActiveData.KeyOpenedType == 1)
					{
						int[] array3 = new int[10] { 10001, 10002, 10003, 10004, 10005, 10006, 10007, 10000, 10009, 10010 };
						chickActiveData.CurrentLvAward += array[num4 - 1];
						list = ActiveMgr.FindChickActivePakage(array3[num4 - 1]);
						title = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.LevelAward.Title", array2[num4 - 1]);
						message = LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.LevelAward.Msg", array2[num4 - 1]);
					}
					if (list != null)
					{
						List<ItemInfo> list2 = new List<ItemInfo>();
						foreach (ActivitySystemItemInfo item3 in list)
						{
							ItemTemplateInfo ıtemTemplateInfo = ItemMgr.FindItemTemplate(item3.TemplateID);
							if (ıtemTemplateInfo != null && (ıtemTemplateInfo.NeedSex == 0 || ıtemTemplateInfo.NeedSex == num5))
							{
								ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ıtemTemplateInfo, item3.Count, 102);
								ıtemInfo.Count = item3.Count;
								ıtemInfo.IsBinds = item3.IsBind;
								ıtemInfo.ValidDate = item3.ValidDate;
								ıtemInfo.StrengthenLevel = item3.StrengthLevel;
								ıtemInfo.AttackCompose = item3.AttackCompose;
								ıtemInfo.DefendCompose = item3.DefendCompose;
								ıtemInfo.AgilityCompose = item3.AgilityCompose;
								ıtemInfo.LuckCompose = item3.LuckCompose;
								list2.Add(ıtemInfo);
							}
						}
						if (list2.Count > 0)
						{
							WorldEventMgr.SendItemsToMail(list2, client.Player.PlayerCharacter.ID, client.Player.PlayerCharacter.NickName, title);
							client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
						}
						client.Player.Actives.SaveChickActiveData(chickActiveData);
						client.Player.Actives.SendUpdateChickActivation();
						client.Out.SendMessage(eMessageType.Normal, message);
						return 0;
					}
					client.Player.SendMessage(LanguageMgr.GetTranslation("ActivityPackageHandler.ChickActivation.NotFoundAward"));
					return 0;
				}
				}
			}
			case 4:
				if (client.Player.MagicHouseHandler != null)
				{
					client.Player.MagicHouseHandler.ProcessData(client.Player, packet);
					return 0;
				}
				return 0;
			default:
				Console.WriteLine("ACTIVITY_PACKAGE not found Cmd {0}", num);
				return 0;
			}
		}

		private bool method_0(int int_1, int int_2)
		{
			switch (int_2)
			{
			case 0:
				if (int_0[int_2] <= int_1)
				{
					return true;
				}
				break;
			case 1:
				if (int_0[int_2] <= int_1)
				{
					return true;
				}
				break;
			case 2:
				if (int_0[int_2] <= int_1)
				{
					return true;
				}
				break;
			case 3:
				if (int_0[int_2] <= int_1)
				{
					return true;
				}
				break;
			case 4:
				if (int_0[int_2] <= int_1)
				{
					return true;
				}
				break;
			case 5:
				if (int_0[int_2] <= int_1)
				{
					return true;
				}
				break;
			case 6:
				if (int_0[int_2] <= int_1)
				{
					return true;
				}
				break;
			case 7:
				if (int_0[int_2] <= int_1)
				{
					return true;
				}
				break;
			case 8:
				if (int_0[int_2] <= int_1)
				{
					return true;
				}
				break;
			}
			return false;
		}

		public ActivityPackageHandler()
		{
			int_0 = new int[9] { 10, 20, 30, 40, 45, 50, 55, 60, 65 };
		}
	}
}
