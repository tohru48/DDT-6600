using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.ActiveSystem.Handle
{
	[Attribute0(2)]
	public class PyramidStartOrStop : IActiveSystemCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(145, Player.PlayerCharacter.ID);
			PyramidInfo pyramid = Player.Actives.Pyramid;
			if (pyramid == null)
			{
				Player.Actives.LoadPyramid();
				pyramid = Player.Actives.Pyramid;
			}
			bool flag = (pyramid.isPyramidStart = packet.ReadBoolean());
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteBoolean(flag);
			if (!flag)
			{
				pyramid.totalPoint += pyramid.totalPoint * pyramid.pointRatio / 100;
				pyramid.totalPoint += pyramid.turnPoint;
				pyramid.turnPoint = 0;
				pyramid.pointRatio = 0;
				pyramid.currentLayer = 1;
				pyramid.currentReviveCount = 0;
				pyramid.LayerItems = "";
				gSPacketIn.WriteInt(pyramid.totalPoint);
				gSPacketIn.WriteInt(pyramid.turnPoint);
				gSPacketIn.WriteInt(pyramid.pointRatio);
				gSPacketIn.WriteInt(pyramid.currentLayer);
			}
			Player.SendTCP(gSPacketIn);
			return true;
		}
	}
}
