using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;


namespace YiLiang.Effect.Grass
{
    [RequireComponent(typeof(MeshFilter))]
    [RequireComponent(typeof(MeshRenderer))]
    public class SimpleMeshCombine : MonoBehaviour
    {
        public void CombineMesh()
        {
            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();
            CombineInstance[] combine = new CombineInstance[meshFilters.Length];

            int i = 0;
            while (i < meshFilters.Length)
            {
                combine[i].mesh = meshFilters[i].sharedMesh;
                combine[i].transform = meshFilters[i].transform.localToWorldMatrix;
                meshFilters[i].gameObject.SetActive(false);

                i++;
            }

            Mesh mesh = new Mesh();
            mesh.name = "CombineMesh111";
            mesh.CombineMeshes(combine);

            transform.GetComponent<MeshFilter>().mesh = mesh;
            transform.gameObject.SetActive(true);

            Mesh tmpMesh = Instantiate<Mesh>(mesh);

            AssetDatabase.CreateAsset(tmpMesh, "Assets/GrassMesh.asset");
        }
    }
}