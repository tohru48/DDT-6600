using System;
using Game.Base.Packets;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
	[GameCommandAttbute(91)]
	public class GamePacket : IGameCommandHandler
	{
		private void method_0(RingStationGamePlayer ringStationGamePlayer_0)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(91);
			gSPacketIn.Parameter1 = ringStationGamePlayer_0.GamePlayerId;
			gSPacketIn.WriteByte(16);
			gSPacketIn.WriteInt(100);
			ringStationGamePlayer_0.method_1(gSPacketIn);
		}

		private void method_1(RingStationGamePlayer ringStationGamePlayer_0, GSPacketIn gspacketIn_0)
		{
			gspacketIn_0.ReadBoolean();
			gspacketIn_0.ReadByte();
			gspacketIn_0.ReadByte();
			gspacketIn_0.ReadByte();
			gspacketIn_0.ReadBoolean();
			gspacketIn_0.ReadInt();
			int num = gspacketIn_0.ReadInt();
			for (int i = 0; i < num; i++)
			{
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
			}
			num = gspacketIn_0.ReadInt();
			for (int j = 0; j < num; j++)
			{
				int num2 = gspacketIn_0.ReadInt();
				bool flag = gspacketIn_0.ReadBoolean();
				if (num2 == ringStationGamePlayer_0.GamePlayerId)
				{
					ringStationGamePlayer_0.X = gspacketIn_0.ReadInt();
					ringStationGamePlayer_0.Y = gspacketIn_0.ReadInt();
				}
				else if (flag)
				{
					ringStationGamePlayer_0.LX = gspacketIn_0.ReadInt();
					ringStationGamePlayer_0.LY = gspacketIn_0.ReadInt();
				}
				else
				{
					gspacketIn_0.ReadInt();
					gspacketIn_0.ReadInt();
				}
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadBoolean();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				ringStationGamePlayer_0.Dander = gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
			}
			gspacketIn_0.ReadInt();
			method_8(ringStationGamePlayer_0, gspacketIn_0.Parameter1 == ringStationGamePlayer_0.GamePlayerId);
		}

		private void method_2(RingStationGamePlayer ringStationGamePlayer_0, int int_0)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(91);
			gSPacketIn.Parameter1 = ringStationGamePlayer_0.GamePlayerId;
			gSPacketIn.WriteByte(7);
			gSPacketIn.WriteInt(int_0);
			ringStationGamePlayer_0.method_1(gSPacketIn);
		}

		private void method_3(RingStationGamePlayer ringStationGamePlayer_0)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(91);
			gSPacketIn.Parameter1 = ringStationGamePlayer_0.GamePlayerId;
			gSPacketIn.WriteByte(12);
			gSPacketIn.WriteByte(100);
			ringStationGamePlayer_0.method_1(gSPacketIn);
		}

		private void method_4(RingStationGamePlayer ringStationGamePlayer_0, bool bool_0, int int_0)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(91);
			gSPacketIn.Parameter1 = ringStationGamePlayer_0.GamePlayerId;
			gSPacketIn.WriteByte(96);
			gSPacketIn.WriteBoolean(bool_0);
			gSPacketIn.WriteByte((byte)int_0);
			ringStationGamePlayer_0.method_1(gSPacketIn);
		}

		private void method_5(RingStationGamePlayer ringStationGamePlayer_0, int int_0)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(91);
			gSPacketIn.Parameter1 = ringStationGamePlayer_0.GamePlayerId;
			gSPacketIn.WriteByte(32);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(-1);
			gSPacketIn.WriteInt(int_0);
			ringStationGamePlayer_0.method_1(gSPacketIn);
		}

		private void method_6(RingStationGamePlayer ringStationGamePlayer_0, int int_0)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(91);
			gSPacketIn.Parameter1 = ringStationGamePlayer_0.GamePlayerId;
			gSPacketIn.WriteByte(15);
			gSPacketIn.WriteInt(int_0);
			ringStationGamePlayer_0.method_1(gSPacketIn);
		}

		public static double ComputeVx(double dx, float m, float af, float f, float t)
		{
			return (dx - (double)(f / m * t * t / 2f)) / (double)t + (double)(af / m) * dx * 0.8;
		}

		public static double ComputeVy(double dx, float m, float af, float f, float t)
		{
			return (dx - (double)(f / m * t * t / 2f)) / (double)t + (double)(af / m) * dx * 1.3;
		}

		private void method_7(RingStationGamePlayer ringStationGamePlayer_0, int int_0, int int_1, int int_2, int int_3)
		{
			GSPacketIn gSPacketIn = new GSPacketIn(91);
			gSPacketIn.Parameter1 = ringStationGamePlayer_0.GamePlayerId;
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(int_0);
			gSPacketIn.WriteInt(int_1);
			gSPacketIn.WriteInt(int_2);
			gSPacketIn.WriteInt(int_3);
			ringStationGamePlayer_0.method_1(gSPacketIn);
		}

		private void method_8(RingStationGamePlayer ringStationGamePlayer_0, bool bool_0)
		{
			if (!bool_0)
			{
				return;
			}
			if (ringStationGamePlayer_0.ShootCount > 0)
			{
				ringStationGamePlayer_0.ShootCount--;
				int num = ((ringStationGamePlayer_0.LX > ringStationGamePlayer_0.X) ? 1 : (-1));
				if (ringStationGamePlayer_0.FirtDirection || ringStationGamePlayer_0.Direction != num)
				{
					ringStationGamePlayer_0.FirtDirection = false;
					ringStationGamePlayer_0.Direction = num;
					method_2(ringStationGamePlayer_0, num);
				}
				int int_ = 0;
				int int_2 = 0;
				float num2 = ringStationGamePlayer_0.LX - ringStationGamePlayer_0.X;
				float num3 = ringStationGamePlayer_0.LY - ringStationGamePlayer_0.Y;
				float af = 2f;
				float f = 7000f;
				float f2 = 0f;
				float m = 10f;
				float num4 = 2f;
				if (num4 <= 4f)
				{
					double num5 = ComputeVx(num2, m, af, f2, num4);
					double num6 = ComputeVy(num3, m, af, f, num4);
					if (num6 < 0.0 && num5 * (double)num > 0.0)
					{
						double num7 = Math.Sqrt(num5 * num5 + num6 * num6);
						if (num7 < 2000.0)
						{
							int_ = (int)num7;
							int_2 = (int)(Math.Atan(num6 / num5) / Math.PI * 180.0);
							if (num5 < 0.0)
							{
								int_2 += 180;
							}
							goto IL_0246;
						}
					}
					if (ringStationGamePlayer_0.Grade > 10)
					{
						method_5(ringStationGamePlayer_0, 10004);
						method_5(ringStationGamePlayer_0, 10004);
						method_5(ringStationGamePlayer_0, 10006);
					}
					else
					{
						method_5(ringStationGamePlayer_0, 10008);
					}
					if (ringStationGamePlayer_0.Dander >= 200)
					{
						method_6(ringStationGamePlayer_0, 0);
						ringStationGamePlayer_0.Dander = 0;
					}
					method_4(ringStationGamePlayer_0, bool_0: true, 0);
					method_7(ringStationGamePlayer_0, ringStationGamePlayer_0.X, ringStationGamePlayer_0.Y - 25, int_, int_2);
					return;
				}
			}
			goto IL_0246;
			IL_0246:
			ringStationGamePlayer_0.CurRoom.RemovePlayer(ringStationGamePlayer_0);
		}

		private void method_9(RingStationGamePlayer ringStationGamePlayer_0, GSPacketIn gspacketIn_0)
		{
			ringStationGamePlayer_0.ShootCount = 100;
			ringStationGamePlayer_0.FirtDirection = true;
			ringStationGamePlayer_0.Direction = -1;
			gspacketIn_0.ReadInt();
			gspacketIn_0.ReadInt();
			gspacketIn_0.ReadInt();
			int num = gspacketIn_0.ReadInt();
			for (int i = 0; i < num; i++)
			{
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadString();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadString();
				gspacketIn_0.ReadBoolean();
				gspacketIn_0.ReadByte();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadBoolean();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadString();
				gspacketIn_0.ReadString();
				gspacketIn_0.ReadString();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				if (gspacketIn_0.ReadInt() != 0)
				{
					gspacketIn_0.ReadInt();
					gspacketIn_0.ReadString();
					gspacketIn_0.ReadDateTime();
				}
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadBoolean();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadString();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadString();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadString();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadBoolean();
				gspacketIn_0.ReadInt();
				if (gspacketIn_0.ReadBoolean())
				{
					gspacketIn_0.ReadInt();
					gspacketIn_0.ReadString();
				}
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				int team = gspacketIn_0.ReadInt();
				int num2 = gspacketIn_0.ReadInt();
				gspacketIn_0.ReadInt();
				if (ringStationGamePlayer_0.GamePlayerId == num2)
				{
					ringStationGamePlayer_0.Team = team;
				}
				int num3 = gspacketIn_0.ReadInt();
				for (int j = 0; j < num3; j++)
				{
					gspacketIn_0.ReadInt();
					gspacketIn_0.ReadInt();
					gspacketIn_0.ReadInt();
					gspacketIn_0.ReadString();
					gspacketIn_0.ReadInt();
					gspacketIn_0.ReadInt();
					int num4 = gspacketIn_0.ReadInt();
					for (int k = 0; k < num4; k++)
					{
						gspacketIn_0.ReadInt();
						gspacketIn_0.ReadInt();
					}
				}
				int num5 = gspacketIn_0.ReadInt();
				for (int l = 0; l < num5; l++)
				{
					gspacketIn_0.ReadInt();
				}
			}
		}

		public bool HandleCommand(RingStationRoomLogicProcessor process, RingStationGamePlayer player, GSPacketIn packet)
		{
			byte b = packet.ReadByte();
			byte b2 = b;
			if (b2 <= 103)
			{
				switch (b2)
				{
				case 100:
					player.CurRoom.RemovePlayer(player);
					break;
				case 101:
					method_9(player, packet);
					break;
				case 103:
					method_0(player);
					break;
				case 6:
					method_1(player, packet);
					break;
				}
			}
			else if (b2 != 131 && b2 == 241)
			{
			}
			return true;
		}
	}
}
