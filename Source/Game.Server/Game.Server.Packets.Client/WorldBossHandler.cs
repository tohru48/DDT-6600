using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.Buffer;
using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
	[PacketHandler(102, "场景用户离开")]
	public class WorldBossHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			if (!RoomMgr.WorldBossRoom.worldOpen)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(LanguageMgr.GetTranslation("WorldBossHandler.Msg")));
				return 0;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(102, client.Player.PlayerCharacter.ID);
			switch (b)
			{
			case 32:
				gSPacketIn.WriteByte(2);
				gSPacketIn.WriteBoolean(val: true);
				gSPacketIn.WriteBoolean(val: false);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				client.Out.SendTCP(gSPacketIn);
				return 0;
			case 33:
				RoomMgr.WorldBossRoom.RemovePlayer(client.Player);
				client.Player.ClearFightBuffOneMatch();
				break;
			case 34:
			{
				int x = packet.ReadInt();
				int y = packet.ReadInt();
				client.Player.X = x;
				client.Player.Y = y;
				if (client.Player.CurrentRoom != null)
				{
					client.Player.CurrentRoom.RemovePlayerUnsafe(client.Player);
				}
				if (RoomMgr.WorldBossRoom.AddPlayer(client.Player))
				{
					RoomMgr.WorldBossRoom.ViewOtherPlayerRoom(client.Player);
				}
				break;
			}
			case 35:
			{
				int num = packet.ReadInt();
				int num2 = packet.ReadInt();
				string str = packet.ReadString();
				gSPacketIn.WriteByte(6);
				gSPacketIn.WriteInt(client.Player.PlayerId);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteInt(num2);
				gSPacketIn.WriteString(str);
				client.Player.SendTCP(gSPacketIn);
				RoomMgr.WorldBossRoom.method_1(gSPacketIn, client.Player);
				client.Player.X = num;
				client.Player.Y = num2;
				break;
			}
			case 36:
			{
				byte b2 = packet.ReadByte();
				if (b2 != 3 || client.Player.States != 3)
				{
					gSPacketIn.WriteByte(7);
					gSPacketIn.WriteInt(client.Player.PlayerId);
					gSPacketIn.WriteByte(b2);
					gSPacketIn.WriteInt(client.Player.X);
					gSPacketIn.WriteInt(client.Player.Y);
					RoomMgr.WorldBossRoom.method_0(gSPacketIn);
					if (b2 == 3 && client.Player.CurrentRoom.Game != null)
					{
						client.Player.CurrentRoom.RemovePlayerUnsafe(client.Player);
					}
					string nickName = client.Player.PlayerCharacter.NickName;
					RoomMgr.WorldBossRoom.SendPrivateInfo(nickName);
				}
				client.Player.States = b2;
				break;
			}
			case 37:
			{
				int num3 = packet.ReadInt();
				packet.ReadBoolean();
				int value = RoomMgr.WorldBossRoom.reviveMoney;
				if (num3 == 2)
				{
					value = RoomMgr.WorldBossRoom.reFightMoney;
				}
				if (client.Player.MoneyDirect(value))
				{
					gSPacketIn.WriteByte(11);
					gSPacketIn.WriteInt(client.Player.PlayerId);
					RoomMgr.WorldBossRoom.method_0(gSPacketIn);
				}
				break;
			}
			case 38:
			{
				int addInjureBuffMoney = RoomMgr.WorldBossRoom.addInjureBuffMoney;
				int addInjureValue = RoomMgr.WorldBossRoom.addInjureValue;
				if (client.Player.MoneyDirect(addInjureBuffMoney))
				{
					client.Player.RemoveMoney(addInjureBuffMoney);
					BufferList.CreatePayBuffer(403, addInjureValue, 1)?.Start(client.Player);
				}
				break;
			}
			default:
				Console.WriteLine("WorldBossPackageType." + (WorldBossPackageType)b);
				break;
			}
			return 0;
		}
	}
}
