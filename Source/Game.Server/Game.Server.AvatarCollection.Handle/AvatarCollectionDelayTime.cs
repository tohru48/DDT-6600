using System;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.AvatarCollection.Handle
{
	[Attribute1(4)]
	public class AvatarCollectionDelayTime : IAvatarCollectionCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			ClothPropertyTemplateInfo clothPropertyTemplateInfo = AvatarColectionMgr.FindClothPropertyTemplate(num);
			if (clothPropertyTemplateInfo == null)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("AvatarColection.Msg3"));
				return false;
			}
			long num3 = clothPropertyTemplateInfo.Cost * num2;
			int num4 = (int)((num3 > int.MaxValue) ? int.MaxValue : num3);
			if (Player.PlayerCharacter.myHonor < num4)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("AvatarColection.Msg4"));
				return false;
			}
			DateTime delayTime = DateTime.Now;
			int mySex = 1;
			bool updateProp = false;
			if (!Player.AvatarBag.DelayAvatarColection(num, num2, ref delayTime, ref mySex, ref updateProp))
			{
				Player.SendMessage(LanguageMgr.GetTranslation("AvatarColection.Msg5"));
			}
			else
			{
				Player.RemovemyHonor(num4);
				GSPacketIn gSPacketIn = new GSPacketIn(402, Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(4);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteInt(mySex);
				gSPacketIn.WriteDateTime(delayTime);
				Player.SendTCP(gSPacketIn);
				if (updateProp)
				{
					Player.EquipBag.UpdatePlayerProperties();
					Player.AvatarBag.UpdateAvatarColection(sendToClient: true);
				}
			}
			return true;
		}
	}
}
