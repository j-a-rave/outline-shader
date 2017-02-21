using UnityEngine;
using System.Collections;

public class Rotate : MonoBehaviour {

    public float speed;
	Vector3 rotEuler;

	// Use this for initialization
	void Start () {
		rotEuler = this.transform.rotation.eulerAngles;
	}
	
	// Update is called once per frame
	void Update () {
		rotEuler.y -= speed;
		this.transform.rotation = Quaternion.Euler (rotEuler);
	}
}
