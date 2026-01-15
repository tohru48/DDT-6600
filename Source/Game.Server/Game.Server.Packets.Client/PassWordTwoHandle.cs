using System;
using Bussiness;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
	[PacketHandler(25, "二级密码")]
	public class PassWordTwoHandle : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			string translateId = "二级密码";
			bool val = false;
			int val2 = 0;
			bool val3 = false;
			int Count = 0;
			string text = packet.ReadString();
			string passwordTwo = packet.ReadString();
			int num = packet.ReadInt();
			string PasswordQuestion = packet.ReadString();
			string PasswordAnswer = packet.ReadString();
			string PasswordQuestion2 = packet.ReadString();
			string PasswordAnswer2 = packet.ReadString();
			switch (num)
			{
			case 1:
				val2 = 1;
				if (string.IsNullOrEmpty(client.Player.PlayerCharacter.PasswordTwo))
				{
					using PlayerBussiness playerBussiness4 = new PlayerBussiness();
					if (text != "" && playerBussiness4.UpdatePasswordTwo(client.Player.PlayerCharacter.ID, text))
					{
						client.Player.PlayerCharacter.PasswordTwo = text;
						client.Player.PlayerCharacter.IsLocked = false;
						translateId = "SetPassword.success";
					}
					if (PasswordQuestion != "" && PasswordAnswer != "" && PasswordQuestion2 != "" && PasswordAnswer2 != "")
					{
						if (playerBussiness4.UpdatePasswordInfo(client.Player.PlayerCharacter.ID, PasswordQuestion, PasswordAnswer, PasswordQuestion2, PasswordAnswer2, 5))
						{
							client.Player.PlayerCharacter.PasswordQuest1 = PasswordQuestion;
							client.Player.PlayerCharacter.PasswordQuest2 = PasswordAnswer;
							client.Player.PlayerCharacter.FailedPasswordAttemptCount = 5;
							val = true;
							val3 = false;
							translateId = "UpdatePasswordInfo.Success";
						}
						else
						{
							val = false;
						}
					}
					else
					{
						val = true;
						val3 = true;
					}
				}
				else
				{
					translateId = "SetPassword.Fail";
					val = false;
					val3 = false;
				}
				break;
			case 2:
				val2 = 2;
				if (text == client.Player.PlayerCharacter.PasswordTwo)
				{
					client.Player.PlayerCharacter.IsLocked = false;
					translateId = "BagUnlock.success";
					val = true;
				}
				else
				{
					translateId = "PasswordTwo.error";
					val = false;
					val3 = false;
				}
				break;
			case 3:
			{
				if (DateTime.Compare(client.Player.WaitingProcessor.AddSeconds(3.0), DateTime.Now) > 0)
				{
					return 1;
				}
				val2 = 3;
				using (PlayerBussiness playerBussiness3 = new PlayerBussiness())
				{
					playerBussiness3.GetPasswordInfo(client.Player.PlayerCharacter.ID, ref PasswordQuestion, ref PasswordAnswer, ref PasswordQuestion2, ref PasswordAnswer2, ref Count);
					Count--;
					playerBussiness3.UpdatePasswordInfo(client.Player.PlayerCharacter.ID, PasswordQuestion, PasswordAnswer, PasswordQuestion2, PasswordAnswer2, Count);
					if (text == client.Player.PlayerCharacter.PasswordTwo)
					{
						if (playerBussiness3.UpdatePasswordTwo(client.Player.PlayerCharacter.ID, passwordTwo))
						{
							client.Player.PlayerCharacter.IsLocked = false;
							client.Player.PlayerCharacter.PasswordTwo = passwordTwo;
							translateId = "UpdatePasswordTwo.Success";
							val = true;
							val3 = false;
						}
						else
						{
							translateId = "UpdatePasswordTwo.Fail";
							val = false;
							val3 = false;
						}
					}
					else
					{
						translateId = "PasswordTwo.error";
						val = false;
						val3 = false;
					}
				}
				client.Player.WaitingProcessor = DateTime.Now;
				break;
			}
			case 4:
			{
				if (DateTime.Compare(client.Player.WaitingProcessor.AddSeconds(3.0), DateTime.Now) > 0)
				{
					return 1;
				}
				val2 = 4;
				string PasswordAnswer3 = "";
				string passwordTwo2 = "";
				string PasswordAnswer4 = "";
				using (PlayerBussiness playerBussiness2 = new PlayerBussiness())
				{
					playerBussiness2.GetPasswordInfo(client.Player.PlayerCharacter.ID, ref PasswordQuestion, ref PasswordAnswer3, ref PasswordQuestion2, ref PasswordAnswer4, ref Count);
					Count--;
					playerBussiness2.UpdatePasswordInfo(client.Player.PlayerCharacter.ID, PasswordQuestion, PasswordAnswer, PasswordQuestion2, PasswordAnswer2, Count);
					if (PasswordAnswer3 == PasswordAnswer && PasswordAnswer4 == PasswordAnswer2 && PasswordAnswer3 != "" && PasswordAnswer4 != "")
					{
						if (playerBussiness2.UpdatePasswordTwo(client.Player.PlayerCharacter.ID, passwordTwo2))
						{
							client.Player.PlayerCharacter.PasswordTwo = passwordTwo2;
							client.Player.PlayerCharacter.IsLocked = false;
							translateId = "DeletePassword.success";
							val = true;
							val3 = false;
						}
						else
						{
							translateId = "DeletePassword.Fail";
							val = false;
						}
					}
					else if (text == client.Player.PlayerCharacter.PasswordTwo)
					{
						if (playerBussiness2.UpdatePasswordTwo(client.Player.PlayerCharacter.ID, passwordTwo2))
						{
							client.Player.PlayerCharacter.PasswordTwo = passwordTwo2;
							client.Player.PlayerCharacter.IsLocked = false;
							translateId = "DeletePassword.success";
							val = true;
							val3 = false;
						}
					}
					else
					{
						translateId = "DeletePassword.Fail";
						val = false;
					}
				}
				client.Player.WaitingProcessor = DateTime.Now;
				break;
			}
			case 5:
			{
				val2 = 5;
				if (client.Player.PlayerCharacter.PasswordTwo == null || !(PasswordQuestion != "") || !(PasswordAnswer != "") || !(PasswordQuestion2 != "") || !(PasswordAnswer2 != ""))
				{
					break;
				}
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					if (playerBussiness.UpdatePasswordInfo(client.Player.PlayerCharacter.ID, PasswordQuestion, PasswordAnswer, PasswordQuestion2, PasswordAnswer2, 5))
					{
						val = true;
						val3 = false;
						translateId = "UpdatePasswordInfo.Success";
					}
					else
					{
						val = false;
					}
				}
				break;
			}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(25, client.Player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(client.Player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(val2);
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteBoolean(val3);
			gSPacketIn.WriteString(LanguageMgr.GetTranslation(translateId));
			gSPacketIn.WriteInt(Count);
			gSPacketIn.WriteString(PasswordQuestion);
			gSPacketIn.WriteString(PasswordQuestion2);
			client.Out.SendTCP(gSPacketIn);
			return 0;
		}
	}
}
