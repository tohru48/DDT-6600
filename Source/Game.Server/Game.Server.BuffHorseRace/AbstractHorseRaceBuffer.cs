using System;
using SqlDataProvider.Data;

namespace Game.Server.BuffHorseRace
{
	public class AbstractHorseRaceBuffer
	{
		protected BuffHorseRaceInfo m_info;

		protected UserHorseRaceInfo m_player;

		public BuffHorseRaceInfo Info => m_info;

		public AbstractHorseRaceBuffer(BuffHorseRaceInfo info)
		{
			m_info = info;
		}

		public virtual void Start(UserHorseRaceInfo player, UserHorseRaceInfo ower)
		{
			m_info.UserID = player.UserID;
			m_info.OwerID = ower.UserID;
			m_player = player;
			m_player.BuffList.AddBuffer(this);
		}

		public virtual void Stop()
		{
			m_player.BuffList.RemoveBuffer(this);
			m_player = null;
		}

		public bool Check()
		{
			return DateTime.Compare(m_info.StartTime.AddSeconds(m_info.VaildTime), DateTime.Now) >= 0;
		}
	}
}
