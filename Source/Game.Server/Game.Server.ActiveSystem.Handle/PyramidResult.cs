using System.Collections.Generic;
using Bussiness;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(3)]
	public class PyramidResult : IActiveSystemCommandHadler
	{
		public static ThreadSafeRandom random;

		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			PyramidInfo pyramid = Player.Actives.Pyramid;
			if (pyramid == null)
			{
				Player.Actives.LoadPyramid();
				pyramid = Player.Actives.Pyramid;
			}
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			if (pyramid.currentFreeCount < Player.Actives.PyramidConfig.freeCount)
			{
				pyramid.currentFreeCount++;
			}
			else
			{
				int turnCardPrice = Player.Actives.PyramidConfig.turnCardPrice;
				if (!Player.MoneyDirect(turnCardPrice))
				{
					return false;
				}
			}
			bool flag = true;
			string translation;
			if (num < 8)
			{
				List<ItemInfo> pyramidAward = ActiveSystemMgr.GetPyramidAward(num);
				int index = random.Next(pyramidAward.Count);
				ItemInfo ıtemInfo = pyramidAward[index];
				int templateID = ıtemInfo.TemplateID;
				bool val = templateID == 201083;
				bool flag2 = templateID == 201082;
				translation = LanguageMgr.GetTranslation("ActiveSystemHandler.Msg11", ıtemInfo.Template.Name, ıtemInfo.Count);
				if (flag2)
				{
					translation = LanguageMgr.GetTranslation("ActiveSystemHandler.Msg12");
					pyramid.currentLayer++;
					if (pyramid.currentLayer > pyramid.maxLayer)
					{
						pyramid.maxLayer++;
					}
					flag = false;
				}
				pyramid.totalPoint += 10;
				switch (templateID)
				{
				case 201077:
					pyramid.pointRatio += 5;
					translation = LanguageMgr.GetTranslation("ActiveSystemHandler.Msg16");
					flag = false;
					break;
				case 201078:
					pyramid.pointRatio += 10;
					translation = LanguageMgr.GetTranslation("ActiveSystemHandler.Msg17");
					flag = false;
					break;
				case 201079:
					pyramid.turnPoint += 10;
					translation = LanguageMgr.GetTranslation("ActiveSystemHandler.Msg13");
					flag = false;
					break;
				case 201080:
					pyramid.turnPoint += 30;
					translation = LanguageMgr.GetTranslation("ActiveSystemHandler.Msg14");
					flag = false;
					break;
				case 201081:
					pyramid.turnPoint += 50;
					translation = LanguageMgr.GetTranslation("ActiveSystemHandler.Msg15");
					flag = false;
					break;
				}
				if (flag)
				{
					Player.AddTemplate(ıtemInfo, LanguageMgr.GetTranslation("ActiveSystemHandler.Msg18"));
				}
				string text = $"{num}-{templateID}-{num2}";
				if (pyramid.LayerItems == "")
				{
					pyramid.LayerItems = text;
				}
				else
				{
					PyramidInfo pyramidInfo = pyramid;
					pyramidInfo.LayerItems = pyramidInfo.LayerItems + "|" + text;
				}
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteInt(templateID);
				gSPacketIn.WriteInt(num2);
				gSPacketIn.WriteBoolean(val);
				gSPacketIn.WriteBoolean(flag2);
				gSPacketIn.WriteInt(pyramid.currentLayer);
				gSPacketIn.WriteInt(pyramid.maxLayer);
				gSPacketIn.WriteInt(pyramid.totalPoint);
				gSPacketIn.WriteInt(pyramid.turnPoint);
				gSPacketIn.WriteInt(pyramid.pointRatio);
				gSPacketIn.WriteInt(pyramid.currentFreeCount);
				Player.SendTCP(gSPacketIn);
			}
			else
			{
				int num3 = random.Next(49, 501);
				pyramid.turnPoint += num3;
				translation = LanguageMgr.GetTranslation("ActiveSystemHandler.Msg19", num3);
				pyramid.isPyramidStart = false;
				pyramid.currentLayer = 1;
				pyramid.currentReviveCount = 0;
				pyramid.totalPoint += pyramid.totalPoint * pyramid.pointRatio / 100;
				pyramid.totalPoint += pyramid.turnPoint;
				pyramid.turnPoint = 0;
				pyramid.pointRatio = 0;
				gSPacketIn.WriteByte(2);
				gSPacketIn.WriteBoolean(pyramid.isPyramidStart);
				gSPacketIn.WriteInt(pyramid.totalPoint);
				gSPacketIn.WriteInt(pyramid.turnPoint);
				gSPacketIn.WriteInt(pyramid.pointRatio);
				gSPacketIn.WriteInt(pyramid.currentLayer);
				Player.SendTCP(gSPacketIn);
			}
			Player.SendMessage(translation);
			return true;
		}

		static PyramidResult()
		{
			random = new ThreadSafeRandom();
		}
	}
}
