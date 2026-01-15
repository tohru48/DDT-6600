using System;
using System.Collections.Generic;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(135, "场景用户离开")]
	public class TreasureHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int ıD = client.Player.PlayerCharacter.ID;
			GSPacketIn gSPacketIn = new GSPacketIn(135, ıD);
			switch (num)
			{
			case 0:
			{
				client.Player.Treasure.UpdateLoginDay();
				UserTreasureInfo currentTreasure3 = client.Player.Treasure.CurrentTreasure;
				List<TreasureDataInfo> treasureData = client.Player.Treasure.TreasureData;
				List<TreasureDataInfo> treasureDig = client.Player.Treasure.TreasureDig;
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(currentTreasure3.logoinDays);
				gSPacketIn.WriteInt(currentTreasure3.treasure);
				gSPacketIn.WriteInt(currentTreasure3.treasureAdd);
				gSPacketIn.WriteInt(currentTreasure3.friendHelpTimes);
				gSPacketIn.WriteBoolean(currentTreasure3.isEndTreasure);
				gSPacketIn.WriteBoolean(currentTreasure3.isBeginTreasure);
				gSPacketIn.WriteInt(treasureData.Count);
				for (int i = 0; i < treasureData.Count; i++)
				{
					gSPacketIn.WriteInt(treasureData[i].TemplateID);
					gSPacketIn.WriteInt(treasureData[i].ValidDate);
					gSPacketIn.WriteInt(treasureData[i].Count);
				}
				gSPacketIn.WriteInt(treasureDig.Count);
				for (int i = 0; i < treasureDig.Count; i++)
				{
					gSPacketIn.WriteInt(treasureDig[i].TemplateID);
					gSPacketIn.WriteInt(treasureDig[i].pos);
					gSPacketIn.WriteInt(treasureDig[i].ValidDate);
					gSPacketIn.WriteInt(treasureDig[i].Count);
				}
				client.Player.Out.SendTCP(gSPacketIn);
				return 0;
			}
			case 1:
			{
				int num3 = packet.ReadInt();
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(0);
				client.Player.SendTCP(gSPacketIn);
				GamePlayer playerById = WorldMgr.GetPlayerById(num3);
				if (playerById == null)
				{
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						playerBussiness.RemoveIsArrange(num3);
						playerBussiness.UpdateFriendHelpTimes(num3);
						return 0;
					}
				}
				playerById.Farm.ClearIsArrange();
				playerById.Treasure.AddfriendHelpTimes();
				gSPacketIn.ClientID = playerById.PlayerCharacter.ID;
				playerById.SendTCP(gSPacketIn);
				return 0;
			}
			case 2:
			{
				UserTreasureInfo currentTreasure4 = client.Player.Treasure.CurrentTreasure;
				currentTreasure4.isBeginTreasure = false;
				currentTreasure4.isEndTreasure = true;
				gSPacketIn.WriteInt(2);
				gSPacketIn.WriteBoolean(currentTreasure4.isEndTreasure);
				client.Player.SendTCP(gSPacketIn);
				client.Player.Treasure.UpdateUserTreasure(currentTreasure4);
				client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("TreasureHandler.Msg2"));
				return 0;
			}
			case 3:
			{
				int num2 = packet.ReadInt();
				int index = num2 - 1;
				bool flag = true;
				TreasureDataInfo treasureDataInfo = client.Player.Treasure.TreasureData[index];
				if (treasureDataInfo == null)
				{
					return 0;
				}
				UserTreasureInfo currentTreasure2 = client.Player.Treasure.CurrentTreasure;
				if (currentTreasure2.treasure > 0)
				{
					currentTreasure2.treasure--;
				}
				else if (currentTreasure2.treasureAdd > 0)
				{
					currentTreasure2.treasureAdd--;
				}
				else
				{
					flag = false;
				}
				if (flag)
				{
					gSPacketIn.WriteInt(3);
					gSPacketIn.WriteInt(treasureDataInfo.TemplateID);
					gSPacketIn.WriteInt(num2);
					gSPacketIn.WriteInt(treasureDataInfo.Count);
					gSPacketIn.WriteInt(currentTreasure2.treasure);
					gSPacketIn.WriteInt(currentTreasure2.treasureAdd);
					client.Player.Out.SendTCP(gSPacketIn);
					treasureDataInfo.pos = num2;
					client.Player.Treasure.AddTreasureDig(treasureDataInfo, index);
					client.Player.Treasure.UpdateUserTreasure(currentTreasure2);
					ItemInfo ıtemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(treasureDataInfo.TemplateID), treasureDataInfo.Count, 105);
					ıtemInfo.IsBinds = true;
					ıtemInfo.ValidDate = treasureDataInfo.ValidDate;
					client.Player.AddTemplate(ıtemInfo, ıtemInfo.Template.BagType, treasureDataInfo.Count, eGameView.RouletteTypeGet);
					client.Player.SendHideMessage(LanguageMgr.GetTranslation("TreasureHandler.Msg1", ıtemInfo.Template.Name, treasureDataInfo.Count));
					return 0;
				}
				return 0;
			}
			case 6:
			{
				UserTreasureInfo currentTreasure = client.Player.Treasure.CurrentTreasure;
				currentTreasure.isBeginTreasure = true;
				gSPacketIn.WriteInt(6);
				gSPacketIn.WriteBoolean(currentTreasure.isBeginTreasure);
				client.Player.SendTCP(gSPacketIn);
				client.Player.Treasure.UpdateUserTreasure(currentTreasure);
				return 0;
			}
			default:
				Console.WriteLine("//treasure_cmd: " + (TreasurePackageType)num);
				return 0;
			}
		}
	}
}
