using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class AttackBuffer : AbstractBuffer
	{
		public AttackBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(AttackBuffer)) is AttackBuffer attackBuffer)
			{
				attackBuffer.Info.ValidDate += base.Info.ValidDate;
				if (attackBuffer.Info.ValidDate > 30)
				{
					attackBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(attackBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.AttackAddPlus = base.Info.Value;
			}
		}

		public override void Stop()
		{
			m_player.PlayerCharacter.AttackAddPlus = 0;
			base.Stop();
		}
	}
}
