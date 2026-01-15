using System;
using System.Collections.Generic;

namespace Game.Server.BuffHorseRace
{
	public class UserHorseRaceInfo
	{
		private int int_0;

		public bool IsSendSpeed;

		private List<int> list_0;

		private BuffHorseRaceList buffHorseRaceList_0;

		private Random random_0;

		public int UserID { get; set; }

		public string NickName { get; set; }

		public int DefaultSpeed { get; set; }

		public int Speed
		{
			get
			{
				return int_0;
			}
			set
			{
				int_0 = value;
				IsSendSpeed = false;
			}
		}

		public int BuffItem1 { get; set; }

		public int BuffItem2 { get; set; }

		public long LastTimerUpdate { get; set; }

		public int RaceLength { get; set; }

		public DateTime FinishTime { get; set; }

		public int Index { get; set; }

		public int Rank { get; set; }

		public DateTime LastTimeGetBuff1 { get; set; }

		public DateTime LastTimeGetBuff2 { get; set; }

		public BuffHorseRaceList BuffList => buffHorseRaceList_0;

		public UserHorseRaceInfo()
		{
			list_0 = new List<int> { 1, 2, 3, 4, 5, 6 };
		}

		public UserHorseRaceInfo(int userId, string nickName, int mountLevel, int index, int speedDefault)
		{
			list_0 = new List<int> { 1, 2, 3, 4, 5, 6 };
			UserID = userId;
			NickName = nickName;
			DefaultSpeed = speedDefault * mountLevel;
			Speed = speedDefault * mountLevel;
			LastTimerUpdate = GetTimer();
			RaceLength = 0;
			Index = index + 1;
			Rank = 0;
			random_0 = new Random();
			buffHorseRaceList_0 = new BuffHorseRaceList(this);
		}

		public long GetTimer()
		{
			return DateTime.Now.Ticks / 10000;
		}

		public void ChangePos()
		{
			long timer = GetTimer();
			int num = (int)(timer - LastTimerUpdate);
			RaceLength += Speed * num / 1000;
			LastTimerUpdate = timer;
		}

		public void Reset()
		{
			LastTimeGetBuff1 = DateTime.Now;
			LastTimeGetBuff2 = DateTime.Now;
			LastTimerUpdate = GetTimer();
			BuffItem1 = 0;
			BuffItem2 = 0;
			CreateBuff();
		}

		public void CreateBuff()
		{
			list_0 = new List<int> { 1, 2, 3, 5, 6, 7 };
			if (BuffItem1 == 0)
			{
				int index = random_0.Next(0, list_0.Count - 1);
				BuffItem1 = list_0[index];
				list_0.Remove(BuffItem1);
			}
			if (BuffItem2 == 0)
			{
				int index2 = random_0.Next(0, list_0.Count - 1);
				BuffItem2 = list_0[index2];
				list_0.Remove(BuffItem2);
			}
		}

		public bool RemoveBuff(int type)
		{
			bool result = false;
			if (BuffItem1 == type)
			{
				BuffItem1 = 0;
				result = true;
			}
			else if (BuffItem2 == type)
			{
				BuffItem2 = 0;
				result = true;
			}
			return result;
		}

		public bool CheckBuff()
		{
			list_0 = new List<int> { 1, 2, 3, 5, 6, 7 };
			list_0.Remove(BuffItem1);
			list_0.Remove(BuffItem2);
			bool result = false;
			BuffList.Update();
			if (BuffItem1 == 0 && LastTimeGetBuff1 <= DateTime.Now)
			{
				int index = random_0.Next(0, list_0.Count - 1);
				BuffItem1 = list_0[index];
				list_0.Remove(BuffItem1);
				LastTimeGetBuff1 = DateTime.Now.AddSeconds(15.0);
				result = true;
			}
			if (BuffItem2 == 0 && LastTimeGetBuff2 <= DateTime.Now)
			{
				int index2 = random_0.Next(0, list_0.Count - 1);
				BuffItem2 = list_0[index2];
				list_0.Remove(BuffItem2);
				LastTimeGetBuff2 = DateTime.Now.AddSeconds(15.0);
				result = true;
			}
			return result;
		}

		public void Stop()
		{
			BuffList.StopAll();
		}
	}
}
