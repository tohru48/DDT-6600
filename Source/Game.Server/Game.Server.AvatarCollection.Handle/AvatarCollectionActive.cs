using System.IO;
using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.AvatarCollection.Handle
{
	[Attribute1(3)]
	public class AvatarCollectionActive : IAvatarCollectionCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			int num3 = packet.ReadInt();
			if (Player.PlayerCharacter.HasBagPassword && Player.PlayerCharacter.IsLocked)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return false;
			}
			ClothGroupTemplateInfo clothGroupTemplateInfo = AvatarColectionMgr.FindClothGroupTemplateInfo(num, num2, num3);
			if (clothGroupTemplateInfo == null)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("AvatarColection.Msg2"));
				using (StreamWriter w = File.AppendText("logChat.txt"))
				{
					Log("USE [Db_Tank] EXEC\t[dbo].[AddCloath] @ID = " + num + ", @templateId = " + num2 + ", @sex = " + num3, w);
				}
				return false;
			}
			int num4 = 10000;
			if (Player.PlayerCharacter.Gold < num4)
			{
				Player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("AvatarColection.GoldNotEnough"));
				return false;
			}
			if (!Player.AvatarBag.ActiveAvatarColection(num, num2, num3))
			{
				Player.SendMessage(LanguageMgr.GetTranslation("AvatarColection.Msg1"));
				using StreamWriter w = File.AppendText("logChat.txt");
				Log("USE [Db_Tank] EXEC\t[dbo].[AddCloath] @ID = " + num + ", @templateId = " + num2 + ", @sex = " + num3, w);
			}
			else
			{
				Player.AvatarBag.UpdateAvatarColectionInfo(num, num3);
				Player.RemoveGold(num4);
				GSPacketIn gSPacketIn = new GSPacketIn(402, Player.PlayerCharacter.ID);
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteInt(num2);
				gSPacketIn.WriteInt(num3);
				Player.SendTCP(gSPacketIn);
			}
			return true;
		}

		public static void Log(string logMessage, TextWriter w)
		{
			w.WriteLine("  :{0}", logMessage);
		}
	}
}
