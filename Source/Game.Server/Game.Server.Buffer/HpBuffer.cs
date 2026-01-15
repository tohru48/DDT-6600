using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class HpBuffer : AbstractBuffer
	{
		public HpBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(HpBuffer)) is HpBuffer hpBuffer)
			{
				hpBuffer.Info.ValidDate += base.Info.ValidDate;
				if (hpBuffer.Info.ValidDate > 30)
				{
					hpBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(hpBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.HpAddPlus = base.Info.Value;
			}
		}

		public override void Stop()
		{
			m_player.PlayerCharacter.HpAddPlus = 0;
			base.Stop();
		}
	}
}
