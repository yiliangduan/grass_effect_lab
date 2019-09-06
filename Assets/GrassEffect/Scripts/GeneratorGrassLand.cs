using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace YiLiang.Effect.Grass
{
    [System.Serializable]
    public class GrassData
    {
        public GameObject GrassObject;

        public int Prob;
    }

    public class GeneratorGrassLand : MonoBehaviour
    {
        public GrassData[] GrassDatas;

        public int RowGrassNum = 20;

        public int ColumnGrassNum = 20;

        public float RandomPlaceOffset = 0.2f;

        public void Create()
        {
            MeshRenderer meshRenderer = gameObject.GetComponent<MeshRenderer>();

            if (null == meshRenderer)
            {
                Debug.LogError("MeshRenderer is null!");
                return;
            }

            Bounds bound = meshRenderer.bounds;

            float offsetx = bound.size.x / RowGrassNum;
            float offsety = bound.size.z / ColumnGrassNum;

            int probRange = 0;
            for (int i = 0; i < GrassDatas.Length; ++i)
            {
                probRange += GrassDatas[i].Prob;
            }

            for (int i = 0; i < RowGrassNum; ++i)
            {
                for (int j = 0; j < ColumnGrassNum; ++j)
                {
                    int range = UnityEngine.Random.Range(0, probRange);

                    GameObject curShowObject = null;
                    int curAddUpProb = 0;

                    for (int m = 0; m < GrassDatas.Length; ++m)
                    {
                        curAddUpProb += GrassDatas[m].Prob;

                        if (range < curAddUpProb)
                        {
                            curShowObject = GrassDatas[m].GrassObject;
                            break;
                        }
                    }

                    if (null != curShowObject)
                    {
                        GameObject tmpObject = Instantiate(curShowObject);

                        tmpObject.transform.SetParent(transform);

                        float posx = (i + 1) * offsetx + bound.min.x + Random.Range(-RandomPlaceOffset, RandomPlaceOffset);
                        float minx = bound.min.x + 0.2f;
                        float maxx = bound.max.x - 0.2f;
                        posx = posx < minx ? minx : posx > maxx ? maxx : posx;

                        float posz = (j + 1) * offsety + bound.min.z + Random.Range(-RandomPlaceOffset, RandomPlaceOffset);
                        float minz = bound.min.z + 0.2f;
                        float maxz = bound.max.z - 0.2f;
                        posz = posz < minz ? minz : posz > maxz ? maxz : posz;

                        tmpObject.transform.position = new Vector3(posx, 0, posz);
                        tmpObject.transform.rotation = Quaternion.identity;
                        tmpObject.transform.localScale = Vector3.one;
                    }
                }
            }
        }

        public void Remove()
        {
            for (int i = transform.childCount - 1; i >= 0; --i)
            {
                DestroyImmediate(transform.GetChild(i).gameObject, true);
            }
        }
    }
}