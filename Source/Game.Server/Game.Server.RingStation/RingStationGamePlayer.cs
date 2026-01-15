using Game.Base.Packets;
using Game.Server.RingStation.RoomGamePkg;

namespace Game.Server.RingStation
{
	public class RingStationGamePlayer
	{
		private RoomGame roomGame_0;

		public BaseRoomRingStation CurRoom;

		private bool bool_0;

		public int ID { get; set; }

		public string NickName { get; set; }

		public bool Sex { get; set; }

		public int Hide { get; set; }

		public string Style { get; set; }

		public string Colors { get; set; }

		public string Skin { get; set; }

		public int Offer { get; set; }

		public int GP { get; set; }

		public int Grade { get; set; }

		public int Repute { get; set; }

		public int Nimbus { get; set; }

		public int ConsortiaID { get; set; }

		public string ConsortiaName { get; set; }

		public int ConsortiaLevel { get; set; }

		public int ConsortiaRepute { get; set; }

		public int Win { get; set; }

		public int Total { get; set; }

		public int Attack { get; set; }

		public int Defence { get; set; }

		public int Agility { get; set; }

		public int Luck { get; set; }

		public int FightPower { get; set; }

		public int TemplateID { get; set; }

		public double Double_0 { get; set; }

		public float GMExperienceRate { get; set; }

		public float AuncherExperienceRate { get; set; }

		public double OfferAddPlus { get; set; }

		public float Single_0 { get; set; }

		public float AuncherOfferRate { get; set; }

		public float AuncherRichesRate { get; set; }

		public float GMRichesRate { get; set; }

		public double AntiAddictionRate { get; set; }

		public int VIPLevel { get; set; }

		public byte typeVIP { get; set; }

		public int hp { get; set; }

		public string Honor { get; set; }

		public string WeaklessGuildProgressStr { get; set; }

		public int badgeID { get; set; }

		public int GamePlayerId { get; set; }

		public int Team { get; set; }

		public int X { get; set; }

		public int LY { get; set; }

		public int LX { get; set; }

		public int Y { get; set; }

		public int Dander { get; set; }

		public int ShootCount { get; set; }

		public int Direction { get; set; }

		public bool CanUserProp
		{
			get
			{
				return bool_0;
			}
			set
			{
				bool_0 = value;
			}
		}

		public int Healstone { get; set; }

		public int HealstoneCount { get; set; }

		public int SecondWeapon { get; set; }

		public double BaseAttack { get; set; }

		public double BaseDefence { get; set; }

		public double BaseAgility { get; set; }

		public double BaseBlood { get; set; }

		public int StrengthLevel { get; set; }

		public bool FirtDirection { get; set; }

		public RingStationGamePlayer()
		{
			bool_0 = true;
			roomGame_0 = new RoomGame();
		}

		internal void method_0(GSPacketIn gspacketIn_0)
		{
			if (roomGame_0 != null)
			{
				roomGame_0.ProcessData(this, gspacketIn_0);
			}
		}

		internal void method_1(GSPacketIn gspacketIn_0)
		{
			CurRoom.method_1(gspacketIn_0);
		}
	}
}
