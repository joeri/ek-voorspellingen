defmodule EcPredictions.User do
  use EcPredictions.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :favourites, EcPredictions.Favourite

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> base_changeset(params)
    |> cast(params, [:password])
    |> put_pass_hash_if_changed_and_valid()
  end

  @doc """
  Changeset for registering a user
  """
  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp base_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name])
    |> validate_required([:email, :name])
    |> unique_constraint(:email)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  # Update the password if it is not the empty string
  defp put_pass_hash_if_changed_and_valid(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        case pass do
          "" ->
            changeset
          _ ->
            changeset
            |> validate_length(:password, min: 6, max: 100)
            |> put_pass_hash()
        end
      _ ->
        changeset
    end
  end
end
