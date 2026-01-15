using System.Reflection;
using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.SceneMarryRooms;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
	[PacketHandler(241, "礼堂创建")]
	public class MarryRoomCreateHandler : IPacketHandler
	{
		protected static readonly ILog log;

		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			if (!client.Player.PlayerCharacter.IsMarried)
			{
				return 1;
			}
			if (client.Player.PlayerCharacter.IsCreatedMarryRoom)
			{
				return 1;
			}
			if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
			{
				client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
				return 0;
			}
			if (client.Player.CurrentRoom != null)
			{
				client.Player.CurrentRoom.RemovePlayerUnsafe(client.Player);
			}
			if (client.Player.CurrentMarryRoom != null)
			{
				client.Player.CurrentMarryRoom.RemovePlayer(client.Player);
			}
			MarryRoomInfo marryRoomInfo = new MarryRoomInfo();
			marryRoomInfo.Name = packet.ReadString();
			marryRoomInfo.Pwd = packet.ReadString();
			marryRoomInfo.MapIndex = packet.ReadInt();
			marryRoomInfo.AvailTime = packet.ReadInt();
			marryRoomInfo.MaxCount = packet.ReadInt();
			marryRoomInfo.GuestInvite = packet.ReadBoolean();
			marryRoomInfo.RoomIntroduction = packet.ReadString();
			marryRoomInfo.ServerID = GameServer.Instance.Configuration.ServerID;
			marryRoomInfo.IsHymeneal = false;
			string[] array = GameProperties.PRICE_MARRY_ROOM.Split(',');
			if (array.Length < 3)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("MarryRoomCreateMoney node in configuration file is wrong");
				}
				return 1;
			}
			int num;
			switch (marryRoomInfo.AvailTime)
			{
			case 2:
				num = int.Parse(array[0]);
				break;
			case 3:
				num = int.Parse(array[1]);
				break;
			case 4:
				num = int.Parse(array[2]);
				break;
			default:
				num = int.Parse(array[2]);
				marryRoomInfo.AvailTime = 4;
				break;
			}
			if (client.Player.MoneyDirect(num))
			{
				MarryRoom marryRoom = MarryRoomMgr.CreateMarryRoom(client.Player, marryRoomInfo);
				if (marryRoom != null)
				{
					GSPacketIn packet2 = client.Player.Out.SendMarryRoomInfo(client.Player, marryRoom);
					client.Player.Out.SendMarryRoomLogin(client.Player, result: true);
					marryRoom.SendToScenePlayer(packet2);
					CountBussiness.InsertSystemPayCount(client.Player.PlayerCharacter.ID, num, 0, 0, 0);
				}
				return 0;
			}
			return 1;
		}

		static MarryRoomCreateHandler()
		{
			log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
