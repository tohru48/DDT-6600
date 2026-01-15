using SqlDataProvider.Data;

namespace Game.Server.BuffHorseRace
{
	public class CopySpeedBuffer : AbstractHorseRaceBuffer
	{
		private int int_0;

		public CopySpeedBuffer(BuffHorseRaceInfo buffer, int speed)
			: base(buffer)
		{
			int_0 = speed;
		}

		public override void Start(UserHorseRaceInfo player, UserHorseRaceInfo ower)
		{
			if (!(player.BuffList.GetOfType(typeof(CopySpeedBuffer)) is CopySpeedBuffer))
			{
				base.Start(player, ower);
				player.Speed = int_0;
			}
		}

		public override void Stop()
		{
			m_player.Speed = m_player.DefaultSpeed;
			base.Stop();
		}
	}
}
