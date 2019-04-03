using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterGenerator : MonoBehaviour {

	private Mesh waterMesh;
	private MeshFilter meshFilter;
	public int meshSize = 100;
	private float xMin = 0;
	private float xMax = 100;
	private float yMin = 0;
	private float yMax = 100;
	
	private float lerp(float x, float y, float t){
		return x + (y - x) * t;
	}

	private int getIndex(int x, int y, int size){
		return (x*(size+1) + y);
	}
    private void GeneratePlaneMesh(int size){
		float x, z;
		List<Vector3> vertices = new List<Vector3>();
		List<Vector2> uv = new List<Vector2>();
		List<Vector3> normals = new List<Vector3>();
		List<int> triangles = new List<int>();
		// Gen vertices
		for (int i=0; i<=size; i++){
			for (int j=0; j<=size; j++){
				x = lerp(xMin, xMax, i * 1.0f/size);
				z = lerp(yMin, yMax, j * 1.0f/size);
				vertices.Add(new Vector3(x, 0, z));
				uv.Add(new Vector2(i * 1.0f/size, j * 1.0f/size));
				normals.Add(new Vector3(0, 1, 0));
			}
		}
		// Gen triangles
		for (int i=0; i<size; i++){
			for (int j=0; j<size; j++){
				triangles.Add(getIndex(i+1, j, size));
				triangles.Add(getIndex(i, j, size));
				triangles.Add(getIndex(i, j+1, size));
				triangles.Add(getIndex(i+1, j, size));
				triangles.Add(getIndex(i, j+1, size));
				triangles.Add(getIndex(i+1, j+1, size));
			}
		}
		waterMesh.vertices = vertices.ToArray();
		waterMesh.triangles = triangles.ToArray();
		waterMesh.uv = uv.ToArray();
		waterMesh.normals = normals.ToArray();
	}

	/// <summary>
	/// Awake is called when the script instance is being loaded.
	/// </summary>
	void Awake()
	{
		waterMesh = new Mesh();
		meshFilter = GetComponent<MeshFilter>();
		GeneratePlaneMesh(meshSize);
		meshFilter.mesh = waterMesh;
	}

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
