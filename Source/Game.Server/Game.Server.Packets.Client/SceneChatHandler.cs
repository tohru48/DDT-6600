using System;
using System.IO;
using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(19, "用户场景聊天")]
	public class SceneChatHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			packet.ClientID = client.Player.PlayerCharacter.ID;
			byte b = packet.ReadByte();
			bool flag = packet.ReadBoolean();
			packet.ReadString();
			string text = packet.ReadString();
			GSPacketIn gSPacketIn = new GSPacketIn(19, client.Player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(client.Player.ZoneId);
			gSPacketIn.WriteByte(b);
			gSPacketIn.WriteBoolean(flag);
			gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
			gSPacketIn.WriteString(text);
			string[] array = text.Split(';');
			if (array.Length > 1 && array.Length < 5 && array[0].Equals("@@") && verificarAdm(client.Player.PlayerCharacter.NickName))
			{
				if (array[1].Equals("all"))
				{
					GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
					foreach (GamePlayer gamePlayer in allPlayers)
					{
						gamePlayer.SendMessage(client.Player.PlayerCharacter.NickName + ": " + array[2]);
					}
				}
				if (array[1].Equals("login"))
				{
					GamePlayer gamePlayer = WorldMgr.GetClientByPlayerNickName(array[2]);
					GSPacketIn gSPacketIn2 = new GSPacketIn(37, client.Player.PlayerCharacter.ID);
					gSPacketIn2.WriteInt(client.Player.PlayerCharacter.ID);
					gSPacketIn2.WriteString(client.Player.PlayerCharacter.NickName);
					gSPacketIn2.WriteString("Sistema");
					gSPacketIn2.WriteString(" Login: " + gamePlayer.PlayerCharacter.UserName);
					gSPacketIn2.WriteBoolean(val: false);
					client.Player.SendTCP(gSPacketIn2);
				}
				if (array[1].Equals("ban"))
				{
					DateTime date = new DateTime(2050, 7, 2);
					using (ManageBussiness manageBussiness = new ManageBussiness())
					{
						manageBussiness.ForbidPlayerByNickName(array[2], date, isExist: false);
					}
					using (StreamWriter w = File.AppendText("logChat.txt"))
					{
						Log("O Usuário " + array[2] + " foi banido do servidor.", w);
					}
					GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
					foreach (GamePlayer gamePlayer in allPlayers)
					{
						gamePlayer.SendMessage("O Usuário " + array[2] + " foi banido do servidor.");
					}
				}
				if (array[1].Equals("desban"))
				{
					DateTime date = new DateTime(2050, 7, 2);
					using (ManageBussiness manageBussiness = new ManageBussiness())
					{
						manageBussiness.ForbidPlayerByNickName(array[2], date, isExist: true);
					}
					using (StreamWriter w = File.AppendText("logChat.txt"))
					{
						Log("O Usuário " + array[2] + " foi desbanido do servidor.", w);
					}
					GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
					foreach (GamePlayer gamePlayer in allPlayers)
					{
						gamePlayer.SendMessage("O Usuário " + array[2] + " foi desbanido do servidor.");
					}
				}
				if (array[1].Equals("kick"))
				{
					using (ManageBussiness manageBussiness = new ManageBussiness())
					{
						manageBussiness.KitoffUserByNickName(array[2], " ");
					}
					using (StreamWriter w = File.AppendText("logChat.txt"))
					{
						Log("O Usuário " + array[2] + " foi kickado do servidor.", w);
					}
					GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
					foreach (GamePlayer gamePlayer in allPlayers)
					{
						gamePlayer.SendMessage("O Usuário " + array[2] + " foi kickado do servidor.");
					}
				}
				if (array[1].Equals("item"))
				{
					GamePlayer gamePlayer = WorldMgr.GetClientByPlayerNickName(array[2]);
					gamePlayer.SendItemToMail(Convert.ToInt32(array[3]), "NexusTank", "NexusTank");
				}
				if (array[1].Equals("fugura"))
				{
					ProduceBussiness produceBussiness = new ProduceBussiness();
					ClothGroupTemplateInfo[] allClothGroupTemplateInfos = produceBussiness.GetAllClothGroupTemplateInfos();
					GamePlayer gamePlayer = WorldMgr.GetClientByPlayerNickName(array[2]);
					gamePlayer.SendMessage("Envio de Fuguras iniciado, aguarde...");
					ClothGroupTemplateInfo[] array2 = allClothGroupTemplateInfos;
					foreach (ClothGroupTemplateInfo clothGroupTemplateInfo in array2)
					{
						gamePlayer.SendItemToMail(clothGroupTemplateInfo.TemplateID, "NexusTank", "NexusTank Fugura");
					}
					gamePlayer.SendMessage("Envio de Fuguras concluido, bom jogo");
				}
				if (array[1].Equals("online"))
				{
					GSPacketIn gSPacketIn2 = new GSPacketIn(37, client.Player.PlayerCharacter.ID);
					gSPacketIn2.WriteInt(client.Player.PlayerCharacter.ID);
					gSPacketIn2.WriteString(client.Player.PlayerCharacter.NickName);
					gSPacketIn2.WriteString("Sistema");
					gSPacketIn2.WriteString(" Usuarios online: " + WorldMgr.GetAllPlayers().Length);
					gSPacketIn2.WriteBoolean(val: false);
					client.Player.SendTCP(gSPacketIn2);
				}
			}
			if (client.Player.CurrentRoom != null && client.Player.CurrentRoom.RoomType == eRoomType.Match && client.Player.CurrentRoom.Game != null)
			{
				client.Player.CurrentRoom.BattleServer.Server.SendChatMessage(text, client.Player, flag);
				return 1;
			}
			switch (b)
			{
			case 3:
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
				gSPacketIn.WriteInt(client.Player.PlayerCharacter.ConsortiaID);
				GamePlayer[] allPlayers3 = WorldMgr.GetAllPlayers();
				GamePlayer[] array4 = allPlayers3;
				foreach (GamePlayer gamePlayer3 in array4)
				{
					if (gamePlayer3.PlayerCharacter.ConsortiaID == client.Player.PlayerCharacter.ConsortiaID && !gamePlayer3.IsBlackFriend(client.Player.PlayerCharacter.ID))
					{
						gamePlayer3.Out.SendTCP(gSPacketIn);
					}
				}
				break;
			}
			case 9:
				if (client.Player.CurrentMarryRoom == null)
				{
					return 1;
				}
				client.Player.CurrentMarryRoom.SendToAllForScene(gSPacketIn, client.Player.MarryMap);
				break;
			default:
			{
				if (client.Player.CurrentRoom != null)
				{
					if (flag)
					{
						client.Player.CurrentRoom.SendToTeam(gSPacketIn, client.Player.CurrentRoomTeam, client.Player);
					}
					else
					{
						client.Player.CurrentRoom.SendToAll(gSPacketIn);
					}
					break;
				}
				if (DateTime.Compare(client.Player.LastChatTime.AddSeconds(1.0), DateTime.Now) > 0 && b == 5)
				{
					return 1;
				}
				if (flag)
				{
					return 1;
				}
				if (DateTime.Compare(client.Player.LastChatTime.AddSeconds(30.0), DateTime.Now) > 0)
				{
					client.Out.SendMessage(eMessageType.const_3, LanguageMgr.GetTranslation("SceneChatHandler.Fast"));
					return 1;
				}
				client.Player.LastChatTime = DateTime.Now;
				GamePlayer[] allPlayers2 = WorldMgr.GetAllPlayers();
				GamePlayer[] array3 = allPlayers2;
				foreach (GamePlayer gamePlayer2 in array3)
				{
					if (gamePlayer2.CurrentRoom == null && gamePlayer2.CurrentMarryRoom == null && !gamePlayer2.IsBlackFriend(client.Player.PlayerCharacter.ID))
					{
						gamePlayer2.Out.SendTCP(gSPacketIn);
					}
				}
				break;
			}
			}
			return 1;
		}

		public bool verificarAdm(string nick)
		{
			bool result = false;
			string[] array = File.ReadAllLines("configDDtank.txt");
			array[0] = array[1];
			string[] array2 = array;
			foreach (string value in array2)
			{
				if (nick.ToLower().Equals(value))
				{
					result = true;
				}
			}
			return result;
		}

		public static void Log(string logMessage, TextWriter w)
		{
			w.Write("\r\nLog Entry : ");
			w.WriteLine("{0} {1}", DateTime.Now.ToLongTimeString(), DateTime.Now.ToLongDateString());
			w.WriteLine("  :");
			w.WriteLine("  :{0}", logMessage);
			w.WriteLine("-------------------------------");
		}
	}
}
