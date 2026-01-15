using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.PetEffects
{
    public class PetAddBloodAllPlayerAroundEquip : AbstractPetEffect
    {
        private int int_0;
        private int int_1;

        public PetAddBloodAllPlayerAroundEquip(int count, int skillId, string elementID)
          : base(ePetEffectType.PetAddBloodAllPlayerAroundEquip, elementID)
        {
            this.int_0 = count;
            switch (skillId)
            {
                case 43:
                    this.int_1 = 300;
                    break;
                case 45:
                    this.int_1 = 500;
                    break;
                case 46:
                    this.int_1 = 800;
                    break;
            }
        }

        public override bool Start(Living living)
        {
            if (!(living.PetEffectList.GetOfType(ePetEffectType.PetAddBloodAllPlayerAroundEquip) is PetAddBloodAllPlayerAroundEquip ofType))
                return base.Start(living);
            ofType.int_0 = this.int_0;
            return true;
        }

        public override void OnAttached(Living player)
        {
            player.BeginSelfTurn += new LivingEventHandle(this.method_0);
        }

        public override void OnRemoved(Living player)
        {
            player.BeginSelfTurn += new LivingEventHandle(this.method_0);
        }

        private void method_0(Living living_0)
        {
            --this.int_0;
            if (this.int_0 < 0)
            {
                this.Stop();
                living_0.Game.udqMkhsej5(living_0, this.Info, false);
            }
            else
            {
                living_0.SyncAtTime = true;
                living_0.AddBlood(this.int_1);
                living_0.SyncAtTime = false;
                foreach (Living living in living_0.Game.Map.FindAllNearestSameTeam(living_0.X, living_0.Y, 150.0, living_0))
                {
                    if (living != living_0)
                    {
                        living.SyncAtTime = true;
                        living.AddBlood(this.int_1);
                        living.SyncAtTime = false;
                    }
                }
            }
        }
    }
}
