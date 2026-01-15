using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(4)]
	public class PyramidDieevent : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(4);
			PyramidInfo pyramid = Player.Actives.Pyramid;
			if (pyramid == null)
			{
				Player.Actives.LoadPyramid();
				pyramid = Player.Actives.Pyramid;
			}
			if (packet.ReadBoolean())
			{
				int value = Player.Actives.PyramidConfig.revivePrice[pyramid.currentReviveCount];
				if (!Player.MoneyDirect(value))
				{
					return false;
				}
				pyramid.currentReviveCount++;
				gSPacketIn.WriteBoolean(pyramid.isPyramidStart);
				gSPacketIn.WriteInt(pyramid.currentLayer);
				gSPacketIn.WriteInt(pyramid.totalPoint);
				gSPacketIn.WriteInt(pyramid.turnPoint);
				gSPacketIn.WriteInt(pyramid.pointRatio);
				gSPacketIn.WriteInt(pyramid.currentReviveCount);
				Player.SendTCP(gSPacketIn);
			}
			else
			{
				pyramid.isPyramidStart = false;
				pyramid.currentLayer = 1;
				pyramid.currentReviveCount = 0;
				pyramid.totalPoint += pyramid.totalPoint * pyramid.pointRatio / 100;
				pyramid.totalPoint += pyramid.turnPoint;
				pyramid.turnPoint = 0;
				pyramid.pointRatio = 0;
				pyramid.LayerItems = "";
				gSPacketIn.WriteBoolean(pyramid.isPyramidStart);
				gSPacketIn.WriteInt(pyramid.currentLayer);
				gSPacketIn.WriteInt(pyramid.totalPoint);
				gSPacketIn.WriteInt(pyramid.turnPoint);
				gSPacketIn.WriteInt(pyramid.pointRatio);
				gSPacketIn.WriteInt(pyramid.currentReviveCount);
				Player.SendTCP(gSPacketIn);
			}
			return true;
		}
	}
}
