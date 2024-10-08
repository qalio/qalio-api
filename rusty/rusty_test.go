package rusty

import "testing"

func TestInit(t *testing.T) {
	expected := "rusty module initialized"
	if got := Init(); got != expected {
		t.Errorf("Init() = %q, want %q", got, expected)
	}
}
